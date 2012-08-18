require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/util/toast'

# class LocalHistoryActivity
#   def on_create(bundle)
#     set_title 'Domo arigato, Mr Ruboto!'
#
#     self.content_view =
#         linear_layout :orientation => :vertical do
#           @text_view = text_view :text => 'What hath Matz wrought?', :id => 42, :width => :match_parent,
#                                  :gravity => :center, :text_size => 48.0
#           button :text => 'M-x butterfly', :width => :match_parent, :id => 43, :on_click_listener => proc { butterfly }
#         end
#   rescue
#     puts "Exception creating activity: #{$!}"
#     puts $!.backtrace.join("\n")
#   end
#
#   private
#
#   def butterfly
#     @text_view.text = 'What hath Matz wrought!'
#     toast 'Flipped a bit via butterfly'
#   end
#
# end

ruboto_import_widgets :TextView, :LinearLayout, :Button

java_import 'android.content.Context'
java_import 'android.location.LocationManager'

class MyLocationListener
  def initialize(activity)
    @activity = activity
  end

  # Required on the Java side when registered
  def hashCode
    hash
  end

  def onLocationChanged(location)
    @activity.update_location(location)
  end

  def onProviderDisabled(provider)
  end

  def onProviderEnabled(provider)
  end

  def onStatusChanged(provider, status, extras)
  end
end

$activity.start_ruboto_activity("$local_history") do
  def on_create(bundle)
    setTitle 'Ruboto GPS Example'

    @lm = getSystemService(Context::LOCATION_SERVICE)
    @ll = MyLocationListener.new(self)
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
      button :text => "Do it now!", :on_click_listener => @handle_click
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
    toast "Location: #{location.time} #{location.latitude} #{location.longitude}"
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
end