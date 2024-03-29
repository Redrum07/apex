
@RestResource(urlMapping = '/ContactAPI1/*')
global with sharing class ContactResource1 {
    
    @HTTPGet
    global static List<Contact> getContactIdNamesAndLeadSource(){

        RestRequest contactRequest = RestContext.request;
        Map<String,String> contactRequestParams = contactRequest.params;

        Integer contactLimit = Integer.valueOf(contactRequestParams.get('limit'));
        String leadSource = contactRequestParams.get('leadSource');

        List<contact> contactList = [SELECT id,Name FROM Contact WHERE leadSource =:leadSource LIMIT:contactLimit];
        return contactList;
    }


    @HTTPPost
    global static Contact createNewContact(){

        RestRequest contactRequest = RestContext.request;
        String requestBody = contactRequest.requestBody.toString();

        Contact contact = (Contact) JSON.deserialize(requestBody, Contact.class);
        insert contact;

        return contact;
    }

   global class Responsewrapper{
     String success;
     String message;

    
   }
    @HttpDelete
    global static List<Responsewrapper> deleteMulitpleContacts(){

        List<Responsewrapper> responseWrapperList = new List<Responsewrapper>();

        RestRequest contactRequest = RestContext.request;
        String contactRequestURI = contactRequest.requestURI;

        String[] contactIds = (contactRequestURI.substring(contactRequestURI.lastIndexOf('/')+1)).split(',');

        List<Contact> contactsToDelete = new List<Contact>();

        for( String id : contactIds){
            Contact contact = new Contact(Id=id);
            contactsToDelete.add(contact);
        }

        Database.DeleteResult[] deletedCons =  Database.delete(contactsToDelete,false);

        for(Database.DeleteResult dr : deletedCons){

            Responsewrapper wrap = new Responsewrapper();
            if(dr.isSuccess()){
                wrap.success = '1';
                wrap.message = 'Record deleted successfully with id: ' + dr.getId();
            }
            else{
                wrap.success = '0';
                for(Database.Error err : dr.getErrors()){

                   
                    wrap.message = ('The following error has occurred : ');                    
                    wrap.message += err.getStatusCode() + ': ' + err.getMessage();
        
                }
            }
            responseWrapperList.add(wrap);
        }

        return responseWrapperList;
    }

}