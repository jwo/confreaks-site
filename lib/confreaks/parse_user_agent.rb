module Confreaks
  class ParseUserAgent
    # Original Code from:
    # http://github.com/jaxn/parse-user-agent
    # http://github.com/jcn/parse-user-agent

    attr_reader :ostype, :browser, :os_version, :browser_version_major

    def parse(user_agent)
      if '-' == user_agent || user_agent.nil?
       # Rails.logger "#{user_agent} was invalid"
      end

      @user_agent = user_agent

      # fix Opera
      #useragent =~ s/Opera (\d)/Opera\/$1/i;
      if @user_agent
        useragent = @user_agent.gsub(/(Opera [\d])/,'Opera\1')

        # grab all Agent/version strings as 'agents'
        @agents = Array.new

        @user_agent.split(/\s+/).each do |string|
          if string =~ /\//
            @agents<< string
          end
        end
      end

      # cycle through the agents to set browser and version (MSIE is set later)
      if @agents && @agents.length > 0
        @agents.each do |agent|
          parts = agent.split('/')

          @browser = parts[0]
          @browser_version = parts[1]

          if @browser == 'Firefox'
            @browser_version_major = parts[1].slice(0,3)
            @browser_version_minor = parts[1].sub(@browser_version_major,'').sub('.','')

          elsif @browser == 'Safari'
            if parts[1].slice(0,3).to_f < 400
              @browser_version_major = '1'
            else
              @browser_version_major = '2'
            end

          else
            if parts[1]
              @browser_version_major = parts[1].slice(0,1)
            else
              @browser_version_major = "X"
            end
          end

          break if @browser == "Chrome"
        end
      end

      # grab all of the properties (within parens)
      # should be in relation to the agent if possible
      if @user_agent
        @detail = @user_agent

        @user_agent.gsub(/\((.*)\)/,'').split(/\s/).each do |part|
          @detail = @detail.gsub(part,'')
        end

        @detail = @detail.gsub('(','').gsub(')','').lstrip
        @properties = @detail.split(/;\s+/)

        # cycle through the properties to set known quantities
        @properties.each do |property|
          if property =~ /^Win/
            @ostype = 'Windows'
            @os = property

            if parts = property.split(/ /,2)
              if parts[1] =~ /^NT/
                @ostype = 'Windows'

                subparts = parts[1].split(/ /,2)

                if subparts[1] == '5'
                  @os_version = '2000'
                elsif subparts[1] == '5.1'
                  @os_version = 'XP'
                else
                  @os_version = subparts[1]
                end
              end
            end
          end

          if property == 'Macintosh'
            @ostype = 'Macintosh'
            @os = property
          end

          if property =~ /OS X/
            @ostype = 'Macintosh'
            @os_version = 'OS X'
            @os = property
          end

          if property =~ /^Linux/
            @ostype = 'Linux'
            @os = property
          end

          if property =~ /^MSIE/
            @browser = 'MSIE'
            @browser_version = property.gsub('MSIE ', '').lstrip
            @browser_version_major,@browser_version_minor = @browser_version.split('.')
          end
        end
      end

      # total hack - need something better
      if @browser == "Version"
        @browser = "Opera"
      end

      self
    end
  end
end
