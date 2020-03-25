//----------------------------------------------------------------------------------
// UNIT OutConsole
unit ConsoleOut;

interface

uses Windows,Classes;

function GetConsoleOutput(const Command: String; var Output, Errors: TStringList): Boolean;

implementation

function GetConsoleOutput(const Command: String; var Output, Errors: TStringList): Boolean;

var

  StartupInfo: TStartupInfo;

  ProcessInfo: TProcessInformation;

  SecurityAttr: TSecurityAttributes;

  PipeOutputRead: THandle;

  PipeOutputWrite: THandle;

  PipeErrorsRead: THandle;

  PipeErrorsWrite: THandle;

  Succeed: Boolean;

  Buffer: array [0..255] of Char;

  NumberOfBytesRead: DWORD;

  Stream: TMemoryStream;

begin

  //Initialisierung ProcessInfo

  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);


  //Initialisierung SecurityAttr

  FillChar(SecurityAttr, SizeOf(TSecurityAttributes), 0);

  SecurityAttr.nLength := SizeOf(SecurityAttr);

  SecurityAttr.bInheritHandle := true;

  SecurityAttr.lpSecurityDescriptor := nil;


  //Pipes erzeugen

  CreatePipe(PipeOutputRead, PipeOutputWrite, @SecurityAttr, 0);

  CreatePipe(PipeErrorsRead, PipeErrorsWrite, @SecurityAttr, 0);


  //Initialisierung StartupInfo

  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);

  StartupInfo.cb:=SizeOf(StartupInfo);

  StartupInfo.hStdInput := 0;

  StartupInfo.hStdOutput := PipeOutputWrite;

  StartupInfo.hStdError := PipeErrorsWrite;

  StartupInfo.wShowWindow := sw_Hide;

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;


  if  CreateProcess(nil, PChar(command), nil, nil, true,

  CREATE_DEFAULT_ERROR_MODE or CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil,

  StartupInfo, ProcessInfo) then begin

    result:=true;

    //Write-Pipes schließen

    CloseHandle(PipeOutputWrite);

    CloseHandle(PipeErrorsWrite);


    //Ausgabe Read-Pipe auslesen

    Stream := TMemoryStream.Create;

    try

      while true do begin

        succeed := ReadFile(PipeOutputRead, Buffer, 255, NumberOfBytesRead, nil);

        if not succeed then break;

        Stream.Write(Buffer, NumberOfBytesRead);

      end;

      Stream.Position := 0;

      Output.LoadFromStream(Stream);

    finally

      Stream.Free;

    end;

    CloseHandle(PipeOutputRead);


    //Fehler Read-Pipe auslesen

    Stream := TMemoryStream.Create;

    try

      while true do begin

        succeed := ReadFile(PipeErrorsRead, Buffer, 255, NumberOfBytesRead, nil);

        if not succeed then break;

        Stream.Write(Buffer, NumberOfBytesRead);

      end;

      Stream.Position := 0;

      Errors.LoadFromStream(Stream);

    finally

      Stream.Free;

    end;

    CloseHandle(PipeErrorsRead);


    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);

    CloseHandle(ProcessInfo.hProcess);

  end

  else begin

    result:=false;

    CloseHandle(PipeOutputRead);

    CloseHandle(PipeOutputWrite);

    CloseHandle(PipeErrorsRead);

    CloseHandle(PipeErrorsWrite);

  end;

end;

end.

(*
Aufrufbeispiel:

Für die Ausgabe und die Fehler wird zunächst eine Stringliste erzeugt. 
Anschließend wird obige Funktion aufgerufen. Ist sie erfolgreich 
ausgeführt wurden (Rückgabewert ist true), wird die Output-Stringliste 
in einem Memo angezeigt. Um Kommandozeilenbefehle ausführen zu können, 
die keine eigenständigen Anwendungen sind (wie der DOS-Befehl "dir" im 
folgenden Beispiel) muss der Name des Kommandozeileninterpreters davor 
stehen. "cmd.exe" ist das unter Windows NT/2000/XP und "command.com" 
unter Windows 9x. Der Parameter /c sorgt dafür, dass der Kommandozeilenbefehl 
ausgeführt und die Kommandozeile anschließend wieder geschlossen wird.

So kann es dann aussehen:

procedure TForm1.Button1Click(Sender: TObject);

var output, errors: TStringList;

begin

  output:=TStringList.Create;

  try

    errors:=TStringList.Create;

    if GetConsoleOutput('cmd /c dir c:\', output, errors) then

      Memo1.Lines.AddStrings(output);

  finally

    output.free;

    errors.free;

  end;

end;

*)
