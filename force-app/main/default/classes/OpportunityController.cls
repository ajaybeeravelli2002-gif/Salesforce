public with sharing class OpportunityController {
    @AuraEnabled
    public static string updateOpportunities(List<Opportunity> oppsToUpdate) {
        try {
            update oppsToUpdate;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}