/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-17-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-17-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class AccountUtil {
    /**  Create list of Account that have Order records 
        if the Order.Status = Ordered calculate the turnover/ Annual revenue 
        by Sum of Order.TotalAmount
     **/

    public static void updateAccountAmount() {
        Order order;
    List<Account> accounts = [Select Id,(Select Id from Orders), AnnualRevenue From Account];
        for (Account acc : accounts) {
            if(order.AccountId == acc.Id && order.Status == 'Ordered' ){
                acc.AnnualRevenue += order.TotalAmount;
            }
            
        }

        }
    }

    

