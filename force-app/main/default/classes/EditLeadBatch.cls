global class EditLeadBatch implements Database.Batchable<sObject> {
    global Database.queryLocator start(Database.BatchableContext bc){
        return Database.getqueryLocator([Select AnnualRevenue from Account]);
    }
    global void execute(Database.BatchableContext bc, List<Account> Alist){
        for(Account a:Alist){
            if(a.AnnualRevenue<10000){
                a.annualRevenue=100000;
            }
        }
        Update Alist;
    }
    global void finish(Database.BatchableContext bc){
        
    }
}