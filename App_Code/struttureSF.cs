using System.Collections.Generic;

/// <summary>
/// Descrizione di riepilogo per struttureSF
/// </summary>

public class TaskRay
{
    public string Id { get; set; }
    public string Name { get; set; }

    public TASKRAY__Project__r TASKRAY__Project__r { get; set; }

    public Owner Owner { get; set; }
}

public class Owner
{
    public string Name { get; set; }
    public string Email { get; set; }

    public TASKRAY__Project__r TASKRAY__Project__r { get; set; }
}

public class TASKRAY__Project__r
{
    public string Name { get; set; }
    public Contratto Contratto__r { get; set; }
}

public class Contratto
{
    public string Commessa_Aeonvis__c { get; set; }
    public string Projects_Id { get; set; }
}