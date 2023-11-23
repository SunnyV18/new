codeunit 50116 "Restart Job Queue"
{
    Permissions = TableData "Job Queue Entry" = rimd;

    trigger OnRun()
    begin
        JobQueueEntry.Reset;
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
        if JobQueueEntry.FindSet then
            repeat
                JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
            //JobQueueEntry.Restart;
            until JobQueueEntry.Next = 0;
    end;

    var
        JobQueueEntry: Record "Job Queue Entry";
}
