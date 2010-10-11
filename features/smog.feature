Feature: Food
  In order to see test the CloudApp items API
  As a user
  I want to see a lit of items

  Scenario: Get items
    When I run "smog curl --user test@example.com:pass"
    Then the output should contain exactly:
      """
      curl -I --digest -u test@example.com:pass -H "Accept: application/json" "http://my.cloudapp.local/items?page=1&per_page=5"

      """

  Scenario: Get items with etag
    When I run "smog curl --etag abc123"
    Then the output should contain exactly:
      """
      curl -I -H "If-None-Match: \"abc123\"" -H "Accept: application/json" "http://my.cloudapp.local/items?page=1&per_page=5"

      """

  Scenario: Get items with last-modified
    When I run "smog curl --last-modified \"Tue, 05 Oct 2010 13:44:39 GMT\""
    Then the output should contain exactly:
      """
      curl -I -H "If-Modified-Since: Tue, 05 Oct 2010 13:44:39 GMT" -H "Accept: application/json" "http://my.cloudapp.local/items?page=1&per_page=5"

      """
