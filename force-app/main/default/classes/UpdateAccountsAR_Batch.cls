/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-16-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

/**
 * This class is used to create a batch of Accounts to add
 * AnnualRevenue with the Order Amount when Order Status = Ordered
 * ?? where will be the class implemented?? tu run the batch ??
 * 
 **/
global class UpdateAccountsAR_Batch implements Database.Batchable<sObject>, Database.Stateful {
    //Query to return sthe Accounts with Orders
    global String query ;

    global UpdateAccountsAR_Batch(String query){
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
       
        /// Request only accounts that have at least one order with Status 'Ordered'
        return Database.getQueryLocator('Select Id,(Select Status From Orders Where Status = 'Ordered') From Account');
    
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){      
        list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order];
        
        for(Account myAccount : scope){
            myAccount.AnnualRevenue= 0;
            for(Order order : listOrders){
                if (myAccount.Id == order.AccountId) {
                    myAccount.AnnualRevenue += order.TotalAmount;     
                }
            }
        } 
       
        
        update scope; 
        /** for(integer i=0; i < scope.size(); i++){
             Account myAccount = scope[i];
             myAccount.Chiffre_d_affaire__c = 0;
            for(integer j=0; j < listOrders.size(); j++){
                if(listOrders[j].AccountId == myAccount.Id){
                    myAccount.Chiffre_d_affaire__c = myAccount.Chiffre_d_affaire__c + listOrders[j].TotalAmount;
                }        
            }
         **/
    }   

    //add finsh
    global void finish(Database.Batchable info){

    }

}