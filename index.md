---
permalink: /index
---
# PoShExpert
These scripts were created on the expert Powershell class with Tobias Weltner. 
The course was from 05.11.2019 - 07.11.2019 

Everything discussed in the training is documented in chronological order. 
All scripts created by Tobias throughout the training are placed in their respective Day-n folder. 

Scripts that the autor was tasked with are placed within [myScripts](./myScripts). 
All code created was done with powershell 5 and is not guaranteed to run on pwsh core. 

Blog of Tobias: 
https://powershell.one/

## Documentation
{% for item in site.data.nav.entries %}
    [{{ item.title }}]("{{ item.url | relative_url }}")
{% endfor %}
[Day1]("{{ /day1 | relative_url }}")
[Day2]("{{  | relative_url }}")
