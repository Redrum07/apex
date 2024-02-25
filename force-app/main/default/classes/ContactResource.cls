
@RestResource(urlMapping='/ContactAPI/*')
global with sharing class ContactResource {
    
    @HTTPGet
    global static List<Contact> getContactIdAndNames(){
        
        RestRequest contactRequest = RestContext.request;

        String contactRequestURI = contactRequest.requestURI;

        Integer contactLimit = Integer.valueOf(
            contactRequestURI.substring(contactRequestURI.lastIndexOf('/')+1));

        List<Contact> contactList = [SELECT id, name FROM contact LIMIT :contactLimit];
        
        return contactList;
    }
}