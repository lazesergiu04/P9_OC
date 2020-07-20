/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

/** Use this class to provide the page with data  
 * Sum of Orders by sales person  
**/
public with sharing class MyTeamOrdersController {
    public Decimal SumOders{
        get{
			AggregateResult[] groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
           return (Decimal)groupedResults[0].get('total');
        }
        set;
    }
    
}
    

