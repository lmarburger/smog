Feature: Smog
  In order to test that an API respects 304s
  As a user
  I want to query an API

  Scenario: Get items
    When I run the command:
      """
      smog auth=test@example.com:pass "http://my.cloudapp.local/items?page=1&per_page=5"
      """
    Then the output should contain:
      """
      curl -I -s --digest -u test@example.com:pass -H "Accept: application/json" "http://my.cloudapp.local/items?page=1&per_page=5"
          HTTP/1.1 401 Authorization Required
          HTTP/1.1 200 OK
      """
    And the output should match:
      """
      curl -I -s --digest -u test@example.com:pass -H "If-None-Match: \\"[^"]+\\"" -H "If-Modified-Since: [\w,: ]+" -H "Accept: application/json" "http://my.cloudapp.local/items\?page=1&per_page=5"
      """
    And the output should contain:
      """
          HTTP/1.1 401 Authorization Required
          HTTP/1.1 304 Not Modified
      """
