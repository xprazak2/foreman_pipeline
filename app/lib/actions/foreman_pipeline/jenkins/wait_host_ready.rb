module Actions
  module ForemanPipeline
    module Jenkins
      class WaitHostReady < WaitAndPoll
        include Mixins::SshExtension

        private
        
        def poll_external_task
          status = nil
          ip = Socket::getaddrinfo(input[:jenkins_instance_hostname], 'www', nil, Socket::SOCK_STREAM)[0][3]          
          Net::SSH.start(ip, 'root', :keys => [input.fetch(:cert_path)]) do |ssh|
            status = ssh_exec!(ssh, command)
          end          
          output[:jenkins_ip] = ip          
          output[:status] = status
          status[2].to_i == 0
        end

        def command
          c = []
          c << "sudo -u jenkins ssh -i #{input[:jenkins_home]}/.ssh/#{input[:jenkins_instance_hostname]} -o StrictHostKeyChecking=no root@#{input[:host_ip]}"
          c << "'echo"
          c << echo
          c << "'"
          c.join(" ")
        end

        def echo
          '"host ready yet?"'
        end

      end
    end
  end
end