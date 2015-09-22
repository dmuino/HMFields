using Toybox.Time as Time;
using Toybox.System as Sys;

class HMFields {
 	// last 60 seconds - 'current speed' samples 
	var lastSecs = new [60];
	var curPos;
	var expectedHalf;
		
	function initialize() {
		for (var i = 0; i < lastSecs.size(); ++i) {
			lastSecs[i] = 0.0;
		}
		
		curPos = 0;	
	}
		
	function getAverage(a) {
		var count = 0;
		var sum = 0.0;
		for (var i = 0; i < a.size(); ++i) {
			if (a[i] > 0.0) {
				count++;
				sum += a[i];
			}			
		}
		if (count > 0) {
			return sum / count;
		} else {
			return null;
		}
	}
	
	function getNAvg(a, curIdx, n) {
		var start = curIdx - n;
		if (start < 0) {
			start += a.size();
		}
		var count = 0;
		var sum = 0.0;
		for (var i = start; i < (start + n); ++i) {
			var idx = i % a.size();
			if (a[idx] > 0.0) {
				count++;
				sum += a[idx];
			}	
		}
		if (count > 0) {
			return sum / count;
		} else {
			return null;
		}
	}
	
	function toPace(speed) {
		if (speed == null) {
			return null;
		}
		
		var settings = Sys.getDeviceSettings();
		var unit = 1609; // miles
		if (settings.paceUnits == Sys.UNIT_METRIC) {
			unit = 1000; // km
		} 
		return unit / speed;	
	}
	
	function getPredictedHalfTime(info) {
	    // See Activity.Info in the documentation for available information.
		if (info.currentSpeed == null || info.elapsedDistance == null) {
			return expectedHalf;
		}
		 
		var minAvg = getAverage(lastSecs);		
		if (minAvg == null || info.averageSpeed == null) {
			return expectedHalf;
		}
		
		var distanceRemaining = 21100 - info.elapsedDistance;
		var avg = info.currentSpeed * .2 + minAvg * .5 + info.averageSpeed * .3;
				
		var timeRemaining = distanceRemaining / avg;
		expectedHalf = timeRemaining.toLong() + 1 + (info.elapsedTime / 1000);
        return expectedHalf;
	}
	
	function toPercentage(n) {
		if (n != null) {
			var pct = n * 100;
			return n.format("%.0f") + "%";
		} else {
			return "---";
		}	
	}
	
	function toDist(d) {
		if (d == null) {
			return "0.00";
		}
		
		var dist;
		if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) {
			dist = d / 1000.0;
		} else {
			dist = d / 1609.0;
		}
		return dist.format("%.2f", dist);
	}
	
	function toStr(o) {
		if (o != null) {
			return "" + o;
		} else {
			return "---";
		}
	}
	
	function fmtSecs(secs) {
		if (secs == null) {
			return "--:--";
		}
		
		var s = secs.toLong();
		var hours = s / 3600;
		s -= hours * 3600;
		var minutes = s / 60;
		s -= minutes * 60;
		var fmt;
		if (hours > 0) {
			fmt = "" + hours + ":" + minutes.format("%02d");
		} else {
			fmt = "" + minutes + ":" + s.format("%02d");
		}

		return fmt;
	}
	
    function compute(info) {
    	if (info.currentSpeed != null) {
    		var idx = curPos % lastSecs.size();
			curPos++;
			lastSecs[idx] = info.currentSpeed;
		} 
		
		var avg10s = getNAvg(lastSecs, curPos, 10);
		var expectedHalf = getPredictedHalfTime(info);
		var halfSecs = null;
		if (expectedHalf != null && expectedHalf >= 3600) {
			halfSecs = (expectedHalf.toLong() % 60).format("%02d");
		}
		var elapsed = info.elapsedTime;
		var elapsedSecs = null;
		
		if (elapsed != null) {
			elapsed /= 1000;
		
			if (elapsed >= 3600) {
				elapsedSecs = (elapsed.toLong() % 60).format("%02d");
			}
		}
		
		return { 
			"battery" => toPercentage(Sys.getSystemStats().battery),
			"dist" => toDist(info.elapsedDistance),
			"hr" => toStr(info.currentHeartRate),
			"timer" => fmtSecs(elapsed),
			"timerSecs" => elapsedSecs,
			"cadence" => toStr(info.currentCadence),
			"pace10s" =>  fmtSecs(toPace(info.averageSpeed)), 
			"paceAvg" => fmtSecs(toPace(avg10s)),
			"half" => fmtSecs(expectedHalf),
			"halfSecs" => halfSecs 
		};		
    }
}
