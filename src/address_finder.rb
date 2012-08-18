require 'yaml'

java_import 'android.net.http.AndroidHttpClient'
java_import 'org.apache.http.client.methods.HttpGet'
java_import 'org.apache.http.util.EntityUtils'

class AddressFinder
  def self.find_address(activity, location)
    Thread.start do
      begin
        puts "asking google for an adress"
        url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{location.latitude},#{location.longitude}&sensor=true"
        client = AndroidHttpClient.newInstance('eurucamp2012')
        method = HttpGet.new(url)
        if response = EntityUtils.toString(client.execute(method).entity)
          puts "google-ask: success"
          address = YAML.load(response)['results'][0]['formatted_address']
          activity.update_address(address)
        else
          puts "google-ask: fail"
          activity.update_address_failed("Arglbarf. #{response.inspect}")
        end
      end
    end
  end
end
