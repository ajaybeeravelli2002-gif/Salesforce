public with sharing class UserAccounts {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts(Integer offsetValue){
        try{
            system.debug('success');
       		 return [select Name, AnnualRevenue,Description,CreatedDate, ParentID from Account ORDER by CreatedDate DESC limit 5 offset:offsetValue];	
        }
        catch (Exception e) {
            // Throw an AuraHandledException to send a user-friendly error to the LWC
             system.debug(e.getMessage());
            throw new AuraHandledException('Error retrieving contacts: ' + e.getMessage());  
        }
	}
    @AuraEnabled(cacheable=true)
    public static List<Account> getUserAccounts(String recordId,Integer offsetValue){
        if (recordId == null) {
            // Handle case where no ID is passed
            return new List<Account>(); 
        }

        if (recordId == 'all') {
            return UserAccounts.getAllAccounts(offsetValue);
		} else {
            try {
                // You should still validate if the string is a valid Id before querying
                Id ownerId = (Id)recordId;
       		    return [SELECT Name, AnnualRevenue, Description, CreatedDate, ParentID FROM Account WHERE OwnerId = :ownerId ORDER by CreatedDate DESC limit 5 offset:offsetValue];	
            }
            catch (Exception e) {
                throw new AuraHandledException('Error retrieving user accounts: ' + e.getMessage());
            }
        }      
	}
    //for Opportunities
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(String userId,String stage, Integer offsetValue){
        
        try{
            if(userId==null) return new List<Opportunity>();
        	else if(userId=='all'){
                if(stage=='all'){
                    return [select AccountId,Probability,StageName,Name,Account.Name,LastModifiedById,LastModifiedBy.Name from Opportunity Order by AccountId limit 5 OFFSET:offsetValue];
                }
                else {
                    return [select AccountId,Probability,StageName,Name,Account.Name,LastModifiedById,LastModifiedBy.Name from Opportunity where StageName=:stage Order by AccountId limit 5 OFFSET:offsetValue];
                }
            }
            else{
                Id uId=(Id)userID;
                List<Account> acc=[select Id from Account where ownerId=:uId ];
                if(stage=='all'){
                    return [select AccountId,Probability,StageName,Name,Account.Name,LastModifiedById,LastModifiedBy.Name from Opportunity where (AccountId in :acc)  Order by AccountId limit 5 OFFSET:offsetValue];
                }
                else{
                	return [select AccountId,Probability,StageName,Name,Account.Name,LastModifiedById,LastModifiedBy.Name from Opportunity where (AccountId in :acc) AND (StageName=:stage) Order by AccountId limit 5 OFFSET:offsetValue];
                }
             }
          }
        catch(Exception e){
            throw new AuraHandledException('Error retrieving user accounts: ' + e.getMessage());
        }
    }
    //for Cases
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(String userId,String caseStatus, Integer offsetValue){
        try{
            if(userId==null) return new List<Case>();
        	else if(userId=='all'){
                if(caseStatus=='all'){
                    return [select AccountId,Subject,Description,Account.Name from Case Order by CreatedDate limit 5 OFFSET:offsetValue];
                }
                else {
                    return [select AccountId,Subject,Description,Account.Name from Case where Status=:caseStatus Order by CreatedDate limit 5 OFFSET:offsetValue];
                }
            }
            else{
                Id uId=(Id)userID;
                List<Account> acc=[select Id from Account where ownerId=:uId ];
                if(caseStatus=='all'){
                    return [select AccountId,Subject,Description,Account.Name from Case where AccountId in :acc  Order by CreatedDate limit 5 OFFSET:offsetValue];
                }
                else{
                	return [select AccountId,Subject,Description,Account.Name from Case where (AccountId in :acc) AND (Status=:caseStatus) Order by createdDate limit 5 OFFSET:offsetValue];
                }
             }
          }
        catch(Exception e){
            throw new AuraHandledException('Error retrieving user cases: ' + e.getMessage());
        }
    }
    
    ////
    @AuraEnabled(cacheable=true)
    public static void eAccounts(List<Account> acc){
        try{
            update acc;
		}
        catch(Exception e){
            throw new AuraHandledException('Error retrieving user cases: ' + e.getMessage());
        }
    }
    
    
}