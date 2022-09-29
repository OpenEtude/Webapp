<% 
long free=Runtime.getRuntime().freeMemory()
long total=Runtime.getRuntime().totalMemory() 
def format = new java.text.DecimalFormat("#####0M")
def freem = format.format(free/1024/1024)
def totalm = format.format(total/1024/1024)
%>
<span style="font: 11px verdana, arial, helvetica, sans-serif;">M&eacute;moire de l'application :</span><br><br><div style="border: 1px solid rgb(0, 0, 0); width: 260px; text-align: center; background-color: rgb(153, 153, 153);font: 11px verdana, arial, helvetica, sans-serif;line-height: 12px;-moz-border-radius: 0.50em;-webkit-border-radius: 0.50em;
"><div style="padding: 4px; background-color: rgb(85, 255, 85);-moz-border-radius: 0.50em;-webkit-border-radius: 0.50em; width: ${((100*free)/total).toInteger()}%;">${freem}&nbsp;/&nbsp;${totalm}</div></div>
