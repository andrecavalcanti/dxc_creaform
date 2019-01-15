pageextension 50030 "DXCItemListExt" extends "Item List" //MyTargetPageId
{
    layout
    {
        // >> AMC-67
        addafter(Description)
        {
            field("Description 2";"Description 2")
            {
                
            }
        }
        // << AMC-67


    }
    
    actions
    {
    }
}