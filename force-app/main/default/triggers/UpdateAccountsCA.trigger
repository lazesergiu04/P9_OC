/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-15-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
trigger UpdateAccountCA on Order (after update) {

	Order newOrder;
    set<Id> setAccountIds = new set<Id>();
    List<Account> acc = [SELECT Id,Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
    for(Account currentAccount : acc){ 
        currentAccount.Chiffre_d_affaire__c = acc.Chiffre_d_affair__c + newOrder.TotalAmount;
      }
      update(acc);
    }
    
    

        // Ciffre d affaire does not exist- translation Turover / AnualRevenue ?? 


        /**set<Id> setAccountIds = new set<Id>();
         * setAccountsId is empty and never used
    
    for(integer i=0; i< trigger.new.size(); i++){
        Order newOrder= trigger.new[i];
       
        Account acc = [SELECT Id,TotalAmount FROM Account WHERE Id =:newOrder.AccountId ];
        acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + newOrder.TotalAmount;
        update acc;
         * 
         * 
         * 
         */
    
