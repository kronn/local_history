require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/util/toast'

require 'address_finder'
require 'location_listener'

ruboto_import_widgets :TextView, :LinearLayout, :Button

java_import 'android.content.Context'
java_import 'android.location.LocationManager'

$activity.start_ruboto_activity("$local_history") do
  def on_create(bundle)
    setTitle 'Local History'

    @lm = getSystemService(Context::LOCATION_SERVICE)
    @ll = LocationListener.new(self)
    @lm.requestLocationUpdates(LocationManager::GPS_PROVIDER, 1000, 0.5, @ll)

    self.content_view = linear_layout(:orientation => :vertical) do
      linear_layout do
        text_view :text => 'Time: '
        @time_view = text_view :text => ''
      end
      linear_layout do
        text_view :text => 'Lat: '
        @lat_view = text_view :text => ''
      end
      linear_layout do
        text_view :text => 'Lng: '
        @lng_view = text_view :text => ''
      end
      linear_layout do
        text_view :text => 'Address: '
        @address_view = text_view :text => ''
      end
      button :text => "Do it now!", :on_click_listener => @handle_click
      button :text => "Reset", :on_click_listener => @handle_reset
    end
  end

  def on_pause
    # Not sure why this is needed, but it's hanging without it.
    begin
      @lm.removeUpdates(@ll)
    rescue
    end
  end

  def update_location(location)
    @time_view.text = Time.at(location.time / 1000).strftime('%Y-%m-%d %H:%M:%S')
    @lat_view.text = location.latitude.to_s
    @lng_view.text = location.longitude.to_s
    toast "Location found"
    AddressFinder.find_address(self, location)
  end

  def update_address(address)
    run_on_ui_thread do
      @address_view.text = address
      toast "Address: #{address}"
    end
  end

  def update_address_failed(message)
    run_on_ui_thread do
      @address_view.text = message
    end
  end

  @handle_click = proc do |view|
    begin
      gps_enabled = @lm.isProviderEnabled(LocationManager::GPS_PROVIDER)
    rescue
      toast "Exception: #{$!}"
      next
    end
    if !gps_enabled
      toast 'GPS is not enabled'
      next
    end
    gps_loc = @lm.getLastKnownLocation(LocationManager::GPS_PROVIDER)
    update_location(gps_loc)
  end
  @handle_reset = proc do |view|
    begin
      @time_view.text = ''
      @lat_view.text = ''
      @lng_view.text = ''
      @address_view.text = ''
    end
  end
end
