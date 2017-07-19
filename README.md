1) Create google application as described at https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-you-command-line-authorization
2) Make those env variables:
  GOOGLE_CLIENT_ID - contains id of your google client
  GOOGLE_CLIENT_SECRET - contains secret of your google application
  GOOGLE_SPREADSHEET_NAME - contains google sheet name
3) Put csv file into same folder with parse_upwork_csv.rb
4) Run parse_upwork_csv.rb with ruby parse_upwork_csv.rb . During first launch you have to follow the link, which will appear at terminal window, and paste authorization code   
