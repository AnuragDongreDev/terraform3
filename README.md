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
