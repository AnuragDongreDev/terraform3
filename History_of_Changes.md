1. Create the datasource with AWS SDK authentication, this way the .aws/credentails will be already read or it will be picked from the env. Or else credentials file should work.
2. The same datasource string should be used. in the tf file as explained later.
3. If you remove the id and uid, then datasource also needs to be replaced except the following:
"datasource": {
  "type": "grafana",
  "uid": "-- Grafana --"
}

And uid should be replaced like below:

instead of

"datasource": {
  "type": "cloudwatch",
  "uid": "some-uid"
}

replace with     -- comment - "datasource": "CW - EC2"    No not this. Consisder the following:

"datasource": {
  "type": "cloudwatch",
  "uid": "some-uid"
}


If you dont remove uid and if the dashboardi s already present then the same dashboard is updated.

4.Title needs to be replaced too.
If you remove uid, then a duplicate dashboard with new name is made(provided you provide the :
new name in the end of json looks something like below:
  "title": "EC2 Monitoring2",



5. I did some more changes and terraform apply gave me the following error:


Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

grafana_dashboard.main: Creating...
╷
│ Error: status: 412, body: {"message":"The dashboard has been changed by someone else","status":"version-mismatch"}
│
│   with grafana_dashboard.main,
│   on main.tf line 19, in resource "grafana_dashboard" "main":
│   19: resource "grafana_dashboard" "main" {
│


So the solution was to include the overwrite param like below:

resource "grafana_dashboard" "main" {
  config_json = file("${path.module}/dashboard.json")
  overwrite = true
}
I could also have tried removing the version number in the end of the JSON file. But i thought overwrite is a better option to work with.

6. In grafana for some reason when i apply terraform init and apply it works fine. But the timerange selected is 21st may while today is 27th may. 21st may was the day when i had setup this panel.  Why does all the panels keep going back to 21st May?
   Its is Because my export of grafana was considering the time when it was first made. I changed the following to "now-6h":
"time": {
  "from": "2024-05-21T00:00:00Z",
  "to": "2024-05-21T23:59:59Z"
},
"timepicker": {
  ...
}


changed to:
"time": {
  "from": "now-6h",
  "to": "now"
}

7. For CPU somehow grafana was automatically adjusting the Y-Axis to 60 because the CPU never went beyond it. It is thogh good for visualization and adds good visual and also adjusts automatically to 100 if and when required, i still wanted to make it static to 0-100. Hence i added the following:
-            "axisLabel": "",
+            "axisLabel": "CPU %",
             "axisPlacement": "auto",
             "barAlignment": 0,
             "barWidthFactor": 0.6,
@@ -64,6 +64,8 @@
               "mode": "off"
             }
           },
+          "max": 100,
+          "min": 0,
           "mappings": [],
           "thresholds": {
             "mode": "absolute",
             

