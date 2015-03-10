module Actions
  module Integration
    module Job
      class DeployNewHost < Actions::EntryAction
        include Mixins::UriExtension

        def plan(job)          
          sequence do
            # redeploy = plan_action(Redeploy, job)    
                
            h = { :host => {
                    :id => "random_number",
                    :name => "dummy host",
                    :ip => "192.168.100.103",
                    :mac => "no_mac_here",
                    :params => ["host_params_empty"]
                  },
                  :activation_key => {
                      :cp_id => 544553785444,
                  },
                  :packages => ["cat", "rat", "bat"]
            }

            # plan_action(Jenkins::WaitHostReady, :host_ip => redeploy.output[:host][:ip],
            #                                     :jenkins_instance_hostname => jenkins_hostname(job),
            #                                     :jenkins_home => job.jenkins_instance.jenkins_home,
            #                                     :cert_path => job.jenkins_instance.cert_path)
            
            # plan_action(JenkinsInstance::Keyscan, :cert_path => job.jenkins_instance.cert_path,
            #                                       :jenkins_url => job.jenkins_instance.url,
            #                                       :jenkins_home => job.jenkins_instance.jenkins_home,
            #                                       :host_ip => redeploy.output[:host][:ip])            

            # packages = plan_action(FindPackagesToInstall, :job_id => job.id)
            # project_outputs = []

            hash = {:data => h, :job_id => job.id}
            bulk_build = plan_action(Jenkins::BulkBuild, job.jenkins_projects, hash)
            plan_action(Promote, :job_id => job.id, :job_name => job.name, :build_fails => bulk_build.output[:failed_count])
            # concurrence do
            #   job.jenkins_projects.each do |project|
            #     project_task = plan_action(Jenkins::BuildProject, 
            #                                 :job_id => job.id,
            #                                 :project_id => project.id,
            #                                 :project_name => project.name,
            #                                 :data => h)
            #                                 # :data => redeploy.output.merge({:packages => packages.output[:package_names]}))
            #     project_outputs << {project.name => project_task.output}
            #   end
            # end

            # plan_self(:host => h[:host],#redeploy.output[:host],
            #           :jenkins_projects => project_outputs)

          end
        end

        # def run
        #   output[:host] = input[:host]
        #   output[:jenkins_projects] = input[:jenkins_projects]
        # end

      end
    end
  end
end