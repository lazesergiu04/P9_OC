/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/


global class UpdateAccountsAR_Batch implements Database.Batchable<SObject> {
   
    global UpdateAccountsAR_Batch(){}
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        
        return Database.getQueryLocator('SELECT Id,AnnualRevenue FROM Account WHERE Id IN (SELECT AccountId FROM Order)');
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){      
        list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order];
   		System.debug(listOrders + '-- List Orders');
        
        for(Account myAccount : scope){
            System.debug(myAccount.AnnualRevenue + '-- acc Annual Revenue');
            myAccount.AnnualRevenue= 0;
            for(Order order : listOrders){
                if (myAccount.Id == order.AccountId) {
                    myAccount.AnnualRevenue += order.TotalAmount;     
                }
            }
        } 
        update scope; 
        System.debug(scope + '--scope');
    }   

    global void finish(Database.BatchableContext bc){ }

}