namespace :resque do 
  namespace :pool do
    def rails_env
      fetch(:resque_rails_env) ||
      fetch(:rails_env) ||       # capistrano-rails doesn't automatically set this (yet),
      fetch(:stage)              # so we need to fall back to the stage.
    end


    desc 'Start all the workers and queus'
    task :start do
      on roles(workers) do
        within app_path do
          execute :bundle, :exec, 'resque-pool', "--daemon --environment #{rails_env}"
        end
      end
    end 

    desc 'Gracefully shut down workers and shutdown the manager after all workers are done'
    task :stop do
      on roles(workers) do
        if pid_file_exists? 
          pid = capture(:cat, pid_path)
          if test "kill -0 #{pid} > /dev/null 2>&1"
            execute :kill, "-s QUIT #{pid}"
          else
            info "Process #{pid} from #{pid_path} is not running, cleaning up stale PID file"
            execute :rm, pid_path
          end
        end
      end
    end

    desc 'Gracefully shut down workers and immediately shutdown manager'
    task :stop_immediately do
      on roles(workers) do
        execute :kill, "-s INT `cat #{pid_path}`"
      end
    end

    desc 'Stop the workers and the manager, re-start them (with a different pid)'
    task :full_restart do
      invoke 'resque:pool:stop'

      # Wait for the manager to stop
      on roles(workers) do
        info "Waiting for pool manager to stop.. " 
        if pid_file_exists? 
          pid   = capture(:cat, pid_path)
          tries = 10
          while tries >= 0 and test("kill -0 #{pid} > /dev/null 2>&1")
            tries =- 1
            sleep 5
          end
        end
      end

      invoke 'resque:pool:start'
    end

    desc 'Reload the config file, reload logfiles, restart all workers'
    task :restart do
      on roles(workers) do
        if pid_file_exists? 
          execute :kill, "-s HUP `cat #{pid_path}`"
        else
          invoke 'resque:pool:start'
        end
      end
    end

    def app_path
      File.join(fetch(:deploy_to), 'current')
    end

    def pid_path
      File.join(app_path, '/tmp/pids/resque-pool.pid')
    end

    def pid_file_exists?
      return test("[ -f #{pid_path} ]")
    end

    def workers
      fetch(:resque_server_roles) || :app
    end
  end
end
