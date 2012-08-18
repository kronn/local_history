class LocationListener
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


