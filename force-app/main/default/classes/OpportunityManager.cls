@RestResource(urlMapping='/Opportunities/*')
global with sharing class OpportunityManager {
	@HttpPost
    global static ID createOpportunity(String name, String stage,
    String closedate, String source) {
        Date dt = Date.valueOf(closedate);
        Opportunity newOpportunity = new Opportunity(
        name=name,
        stageName=stage,
        leadSource=source,
        closedate=dt);
     
        insert newOpportunity;
        return newOpportunity.Id;
    }
    
	@HttpGet
    global static Opportunity getOpportunityById() {
        RestRequest request = RestContext.request;
        // grab the oppId from the end of the URL
        String oppId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Opportunity result = [SELECT Name, StageName, LeadSource, Closedate, Probability
        FROM Opportunity
        WHERE Id = :oppId];
        
        return result;
    }
    
    @HttpPut
    global static ID upsertOpportunity(String name, String stage, String closedate, String source, String id) {
        Date dt = Date.valueOf(closedate);
        
        Opportunity thisOpportunity = new Opportunity(
        Id=id,
        name=name,
        stageName=stage,
        leadSource=source,
        closedate=dt);
        
        // Match Opportunity by Id, if present.
        // Otherwise, create new Opportunity.
        upsert thisOpportunity;
        // Return the Opportunity ID.
        return thisOpportunity.Id; 
    }

    @HttpPatch
    global static ID updateOpportunityFields() {
        RestRequest request = RestContext.request;
        System.debug('request.requestURI:'+request.requestURI);
        String OpportunityId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Opportunity thisOpportunity = [SELECT Id FROM Opportunity WHERE Id = :OpportunityId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
        // Set the field and value on the Opportunity sObject
            thisOpportunity.put(fieldName, params.get(fieldName));
         }
        
        update thisOpportunity;
        return thisOpportunity.Id;
    }
    
}