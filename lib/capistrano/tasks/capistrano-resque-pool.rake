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
        execute :kill, "-s QUIT `cat #{pid_path}`"
      end
    end

    desc 'Gracefully shut down workers and immediately shutdown manager'
    task :stop_immediately do
      on roles(workers) do
        execute :kill, "-s INT `cat #{pid_path}`"
      end
    end

    desc 'Reload the config file, reload logfiles, restart all workers'
    task :restart do
      on roles(workers) do
        if test("[ -f #{pid_path} ]")
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

    def workers
      fetch(:resque_server_roles) || :app
    end
  end
end
