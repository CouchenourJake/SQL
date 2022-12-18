Select *
From dbo.dunkin_stores
WHERE (([state] = 'WV' OR [state] = 'MD')
AND (([drive-thru] = 'True') 
OR ([mobile-order] = 'True' AND [curbside-pickup] = 'True')) 
AND ([sat_hrs] != 'Closed')
AND ([loc_lat] !='N/A' OR [loc_long] !='N/A' ))
ORDER BY [zip]