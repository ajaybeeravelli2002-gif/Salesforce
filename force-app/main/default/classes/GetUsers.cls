public with sharing class GetUsers {
	@AuraEnabled(cacheable=true)
    public static List<User> getUserList(){
         try{
       		return [select Name,Username,Id from User];		
        }
        catch (Exception e) {
            // Throw an AuraHandledException to send a user-friendly error to the LWC
            throw new AuraHandledException('Error retrieving contacts: ' + e.getMessage());
        }
        
    }
}