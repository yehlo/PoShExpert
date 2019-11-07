---
permalink: /index
permalink: /
---
# PoShExpert
These scripts were created on the expert Powershell class with Tobias Weltner. 
The course was from 05.11.2019 - 07.11.2019 

Everything discussed in the training is documented in chronological order. 

All code created was done with powershell 5 and is not guaranteed to run on pwsh core or older versions. 

The scripts stored in /code/DayN were all created and presented by Tobias Weltner. 
He is the author of these scriptlets and none of the code will be covered or explained in detail. 
For an explanation of some code visit his ever growing [blog](https://powershell.one/.)

## Pages
If you are not already on the Github pages link please navigate [there](https://yehlo.github.io/PoShExpert/) now. 

## Documentation 
All days were documented seperately. 

{% for item in site.data.days.days %}
[{{ item.title }}]({{ item.url | relative_url }})  
{% endfor %}

### Module from tobias
To toy around with some functions of Tobias' blog you can use his module. 
See the blog for further instructions. 
```install-module -name psonetools -scope CurrentUser -Force``` 


