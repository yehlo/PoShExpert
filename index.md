---
permalink: /index
---
# PoShExpert
These scripts were created on the expert Powershell class with Tobias Weltner. 
The course was from 05.11.2019 - 07.11.2019 

Foreach day the data has been documented and all the scripts were placed in their respective folders. 

Blog of Tobias: 
https://powershell.one/

## Documentation
{% for item in site.data.nav.entries %}
    [{{ item.title }}]("{{ item.url | relative_url }}")
{% endfor %}
[Day1]("{{ /day1 | relative_url }}")
[Day2]("{{  | relative_url }}")
