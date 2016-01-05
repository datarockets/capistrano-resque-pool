namespace :resque do 
  namespace :pool do
    desc 'Start all the workers and queus'
    task :start do
      on roles(workers) do
        within app_path do
          execute :bundle, :exec, 'resque-pool', "--daemon --environment #{fetch(:rails_env)}"
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
        execute :kill, "-s HUP `cat #{pid_path}`"
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
