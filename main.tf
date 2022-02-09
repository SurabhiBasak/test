// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("nth-drive-340808-7b3c7b9789d3.json")}"
 project     = "My First Project"
 region      = "us-central1-a"
}
 
// resource
resource "google_compute_instance" "instance" {
    name = "vm-instance"
    machine_type = "e2-medium"
    zone = "us-central1-a"
 
    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-9"
      }
    }
 
    network_interface {
      network = "default"
      subnetwork = "default"
 
      access_config {
         // Ephemeral IP
      }
    }
 
}

// Creating dashboard
resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "Cloud Monitoring Dashboard",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "CPU Utilization",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=gce_instance AND metric.type=\"compute.googleapis.com/instance/cpu/utilization\"",
                "aggregation": {
                  
                }
              },
              "unitOverride": "1"
            },
            "plotType": "LINE"
          }],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Disk Bytes rate",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "resource.type=gce_instance AND metric.type=\"compute.googleapis.com/instance/disk/read_bytes_count\"",
                "aggregation": {
                  
                }
              },
              "unitOverride": "1"
            },
            "plotType": "STACKED_AREA"
          }],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}

EOF
}
