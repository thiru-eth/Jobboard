
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/** Contract for Workers **/
contract    CApplicant {
  
    string[] public dbStArray; 

    //Structure to hold Applicant Data
    struct stApplicant {
              string sName;
              string sLocation;
              string sApplicant_Type;
              uint nYoE; 
              uint[] nJobIDs;
              uint nApplicationNo;
        }

        // Array of structures to hold all Applicant Details
        stApplicant[] private Applicants; 

    //Structure to store Candidates Vs JobApplied
    struct stJobApplied{
            uint nCandidateID;
            uint nJobID;
            string sCompany_Name;
    }

    stJobApplied[] public JobApplied;
    uint[] nTotal_Applied ;

    // Structure to store candidate rating
    struct stRating{
        uint nCandidateID;
        uint nCompanyID; // Registration Number
        string sCompanyName;
        uint nRating;
    }
    stRating[] Rating;

    //Structure to get Companywise Rating
    struct stCompanywise_Rating {
        string sCompanyName;
        uint nRating;
    }
    stCompanywise_Rating[] stListRating;

    //To add Applicant details
    function add_Applicant ( string memory Name, string memory Location,
                             string memory Application_Type, uint YoE)  external  returns (uint) {
        
        uint nTemp;
        nTemp = new_Applicant( Name, Location, Application_Type, YoE);
        return nTemp;
        }

    //To add Applicant details
    function new_Applicant ( string memory Name, string memory Location,
                             string memory Application_Type, uint YoE)  internal returns (uint) {

        /* Applicant Details:
            Applicant Name
            Applicant Aadhar card
            Applicant location
            Applicant Type : Carpenter, Painter, Electrician, Plummer, Sweeper, Driver, Cleaner
            Total YOE
            Store above details in structure
        */

        stApplicant memory stTemp;
        uint nTempNo;

        stTemp.sName = Name;
        stTemp.sLocation = Location;
        stTemp.sApplicant_Type = Application_Type;
        stTemp.nYoE = YoE;
        stTemp.nApplicationNo = Applicants.length + 10001;
        Applicants.push(stTemp);
        nTempNo = stTemp.nApplicationNo;
        return (nTempNo);
       
    }

    function Get_Total_Applicants() public  returns (uint){
        return Applicants.length;
    }

    //To get applicant dteails - By Applicantion ID - Takes Applicantion ID as input
   function GetApplicat_ByID( uint ApplicationNo) public  returns (string memory , string memory , 
                                                                         string memory , uint, uint) { 

       stApplicant memory stTemp;

       stTemp = Get_App_Details (ApplicationNo);
       return ( stTemp.sName, stTemp.sLocation, stTemp.sApplicant_Type, stTemp.nYoE, stTemp.nApplicationNo);
   }


/* Function to list available applicants by Type. Ex: Painter, Carpenter*/
//Loop through all the elements in the Array
//Check each elemnts, Application Type is equal to the Type requested by User
//If type is  matched then addthe details into another structure array
//Return the resultant array

    //To get applicant details - By Application Type - Takes 'Applicantion Type' as input such as "Painer, Plummer" etc
   function GetApplicat_ByType( string memory stType)  public returns (string memory , string memory , 
                                                                         string memory , uint, uint) { 
       stApplicant memory stTemp;
       string memory stTempType;
       bool bResult;

       for (uint i=0; i< Applicants.length; i++){

            stTempType = Applicants[i].sApplicant_Type;
           
            bResult = CompareString(stTempType, stType) ;
                if (bResult) {
                    stTemp = Applicants[i];
                    return ( stTemp.sName, stTemp.sLocation, stTemp.sApplicant_Type, stTemp.nYoE, stTemp.nApplicationNo);
                } else
                continue;
       }

       
   }


// Function to compare strings
    function CompareString( string memory chainString, string memory inputString )  public returns (bool) {

        // Convert the each character of the string equivalnet 'UTF Byte Value' and store it in a 'Bytes Array'
        // You can achieve the above using 'Abi.EncodedPack' function.

         bytes memory by_chainString;
         bytes memory by_inputString;

        by_chainString = abi.encodePacked(chainString);
        by_inputString = abi.encodePacked(inputString);

        // Coovert the 'Bytes Array' to a 256Bit (32 Bytes) Hash value  uisng keccak hashing algorithm
        bytes32 chain_Str_Hash;
        bytes32 input_Str_Hash;

        chain_Str_Hash = keccak256(by_chainString);
        input_Str_Hash = keccak256(by_inputString);
        

        //Compare the hash values
        if ( chain_Str_Hash == input_Str_Hash) {
            return true;
        } else 
        return false;

    }


   function Get_App_Details( uint ApplicationNo) internal view returns (stApplicant memory) {

       stApplicant memory stTemp;

       for (uint i=0; i< Applicants.length; i++) {
           
           if (ApplicationNo == Applicants[i].nApplicationNo){
               stTemp = Applicants[i];
               break;
           }
           else
           {
               continue;
           }

       }

       return stTemp;

   }

   //Update JobId in candidate Record
   function update_JobID_CRecord( uint nCandidateID, uint nJobID,
                                  string memory sCompany_Name) 
                                  public returns (stJobApplied memory) {
    
    // Add 'mapping' array in 'structure' to strore the JobID and Company Name
    //Add CandiateID, JobID and Company name in the structure

    stJobApplied memory stTemp_JobApplied;

    stTemp_JobApplied.nCandidateID = nCandidateID;
    stTemp_JobApplied.nJobID = nJobID;
    stTemp_JobApplied.sCompany_Name = sCompany_Name;

    JobApplied.push(stTemp_JobApplied);
    return ( stTemp_JobApplied);

   }

   function Get_All_Applicant_Details() pure public {

       stApplicant memory stTemp;
//
       

   }


}

contract  CJobPoratl is CApplicant{
    
    struct stJobDetails{
        uint nJobID;
        string sJobName;
        string sCompanyName;
        string sLocation;
        uint nYoE;
        string sJobDescription; 
    }
    //Structure to store JobDetails
    stJobDetails[] private JobDetails;
    stJobDetails[] public stResultJobs; 

    //Structure to store company details
    struct stCompany{
        uint nRegNo;
        string sCompanyName;
        string sAddress1;
        string sAddress2;
        uint nPinCode;
    }
    stCompany[] Company;
    //Ass Company details
    function add_Company (uint nRegNo, string memory sCompanyName, string memory sAddress1,
                          string memory sAddress2, uint nPincode) 
                          public returns (stCompany memory) {

        stCompany memory stTempCompany;

        stTempCompany.nRegNo = nRegNo;
        stTempCompany.sCompanyName = sCompanyName;                    
        stTempCompany.sAddress1 = sAddress1;  
        stTempCompany.sAddress2 = sAddress2;      
        stTempCompany.nPinCode = nPincode;     

        Company.push(stTempCompany);
        return stTempCompany;
    }

    //Add Job to the portal
    function add_Job_Details(  string memory sJobName, string memory sCompanyName,
                               string memory sLocation,uint nYoE, string memory sDescription) 
                               public  returns (uint){

        stJobDetails memory stTempJob;
        uint nTempNo;

        stTempJob.sJobName = sJobName;
        stTempJob.sLocation = sLocation;
        stTempJob.sJobDescription = sDescription;
        stTempJob.nYoE = nYoE;

        stTempJob.nJobID = JobDetails.length + 20001;
        JobDetails.push(stTempJob);
        nTempNo = stTempJob.nJobID;
        return (nTempNo);
    }

    function get_Job_ByID( uint nJobID ) public  returns (uint , string memory , 
                                                        string memory , uint, 
                                                        string memory ) { 

       stJobDetails memory stTemp;

       stTemp = get_Job_Details (nJobID);
       return ( stTemp.nJobID, stTemp.sJobName, 
                stTemp.sLocation, stTemp.nYoE, 
                stTemp.sJobDescription);
   }

    function get_Job_Details( uint nJobID) public view returns (stJobDetails memory) {

       stJobDetails memory stTemp;

       for (uint i=0; i< JobDetails.length; i++) {
           
           if (nJobID == JobDetails[i].nJobID){
               stTemp = JobDetails[i];
               break;
           }
           else
           {
               continue;
           }
       }
       return stTemp;
   }

     //To get applicant details - By Application Type - Takes 'Applicantion Type' as input such as "Painer, Plummer" etc
   function get_Jobs_ByName( string memory stJobName) public  returns (stJobDetails[] memory) {
       stJobDetails memory stTemp;
       string memory stTempType;
       bool bResult;

       //Clear existing result array
       //stResultJobs = new stJobDetails[](0);
       for (uint s=0; s < stResultJobs.length; s++)
       {
            delete  stResultJobs[s];
       }

       for (uint i=0; i< JobDetails.length; i++){
            stTempType = JobDetails[i].sJobName;

            bResult = CompareString(stTempType, stJobName) ;

                if (bResult) {
                    stTemp = JobDetails[i];
                    stResultJobs.push(stTemp);

                }
       }
    return ( stResultJobs);

}

//To apply Job
function apply_Job (uint nCandidateID, uint nJobID,
                    string memory sCompanyName) public {
    update_JobID_CRecord( nCandidateID, nJobID, sCompanyName);
}
//To get all the jobs applied by the Candidate
function get_All_Jobs_Applied (uint nCandidateID) 
                               public returns (uint[] memory ) {
    uint nCount = 0;
    uint nTemp;
    //Clear the array
    for (uint s=0; s < nTotal_Applied.length; s++)
       {
            delete  nTotal_Applied[s];
       }
    for (uint i=0; i < JobApplied.length; i++){

        nTemp = JobApplied[i].nCandidateID;

        if ( nCandidateID == nTemp){
            nTotal_Applied.push(JobApplied[i].nJobID);
        }
    }
   return nTotal_Applied;
}

function rate_Candidate( uint nCandidateID, uint nCompanyID, 
                         string memory sCompanyName, uint nRating)
                        public returns (stRating memory ){

    // update  the Rating details
    stRating memory stTemp_Rating;

    stTemp_Rating.nCandidateID = nCandidateID;
    stTemp_Rating.nCompanyID = nCompanyID;
    stTemp_Rating.sCompanyName = sCompanyName;
    stTemp_Rating.nRating = nRating;

    Rating.push(stTemp_Rating);
    return ( stTemp_Rating);
}


//Get Candidate rating basedon Candidiate Id
function get_Rating( uint nCandidateID) public returns (uint) {

    uint nTotalRating;
    uint nCompanyCount;
    uint nFinalRating;

    for (uint i=0; i< Rating.length; i++) {

        if (nCandidateID == Rating[i].nCandidateID) {
            nTotalRating += Rating[i].nRating;
            nCompanyCount++;
        }
    }

    nFinalRating = nTotalRating / nCompanyCount;
    return nFinalRating;
}

//Get Companywise Rating for Candidate
function get_Companywise_Rating (uint nCandidateID) public 
                                returns (stCompanywise_Rating[] memory) {


    stCompanywise_Rating memory  stTemp_Companywise_Rating;
     

    //Clear the array
    for (uint s=0; s < stListRating.length; s++)
       {
            delete  stListRating[s];
       }
    for (uint i=0; i < Rating.length; i++){

        if ( nCandidateID == Rating[i].nCandidateID){
            //Fetch Company Name and Rating
            stTemp_Companywise_Rating.sCompanyName = Rating[i].sCompanyName;
            stTemp_Companywise_Rating.nRating = Rating[i].nRating;

            stListRating.push(stTemp_Companywise_Rating);
        }
    }
   return stListRating;


}


function display_Job_Applied () public view returns (stJobApplied[] memory){
    return JobApplied;
}




}



//Get Job / Job Details from Portal
//List available Jobs for Applicant
//Apply for Jobs ( Store who applied for the job details )
//Fetch applied JOb details for Appicants
//Fetch Applied candidates list for Recuriter

//Contract Rating Module
// Provide Rating for an Applicants
// Fetch Rating for an Applicant

