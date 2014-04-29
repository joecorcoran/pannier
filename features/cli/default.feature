Feature: CLI
  In order to manage my assets from the command line
  As a developer
  I want a command line interface

Scenario: Default command displays usage instructions
  When I run `pannier`
  Then the output should contain:
    """
    Available commands
    """
  And the exit status should be 0

Scenario: Viewing usage instructions
  When I run `pannier usage`
  Then the output should contain:
    """
    Available commands
    """
  And the exit status should be 0
