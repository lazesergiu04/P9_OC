/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class MyTeamOrdersController {
    
        
            public decimal SumOders{
                get{
                    AggregateResult groupedResults = [SELECT SUM(TotalAmount__c) total FROM Account];
                    return (decimal)groupedResults.get('total');
        
                }
                set;
            }
        }

    
