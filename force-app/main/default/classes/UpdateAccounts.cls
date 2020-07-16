/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-16-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class Batch01AccountChiffreAffaire implements Database.Batchable<sObject>,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        /// Request only accounts that have at least one order with Status 'Ordered'
        return Database.getQueryLocator('SELECT Id FROM Account');
       // [Select Id, (Select Status from Orders Where Order.Status = 'Ordered') From Account ]
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){      
        list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order];
        
        //for(Account myAccount : scope){} 
         for(integer i=0; i < scope.size(); i++){
             Account myAccount = scope[i];
             myAccount.Chiffre_d_affaire__c = 0;
            for(integer j=0; j < listOrders.size(); j++){
                if(listOrders[j].AccountId == myAccount.Id){
                    myAccount.Chiffre_d_affaire__c = myAccount.Chiffre_d_affaire__c + listOrders[j].TotalAmount;
                }                   
            }
        }
        
        update scope;
    }   

    //add finsh
}