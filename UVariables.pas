unit UVariables;
{��������}

interface
uses classes,UPatternMatcher;
type
  TMemory=class
    vars:TStringList;
    props:TStringList;
    bot_ID:string;   
    //Match:TMatch;
    constructor create;
    destructor Destroy; override;
    procedure setVar(name,value:string); overload; virtual;
    procedure setVar(name:string;index:integer;value:string); overload; virtual;
    function getVar(name:string):string; overload; virtual;
    function getVar(name:string;index:integer):string; overload; virtual;
    procedure ClearVars;


    function getProp(name:string):string;
    procedure setProp(name,value:string);

    Procedure Save;
    Procedure Load;

    function unDelimitChinese(s:string):string;
  end;
var Memory:Tmemory;
implementation
uses sysutils,ULogging;
  constructor TMemory.Create;
    begin
      inherited Create;
      vars:=TStringList.Create;
      vars.Duplicates:=dupError;
      vars.Sorted:=False;
      Props:=TStringList.Create;
      Props.Duplicates:=dupError;
      Props.Sorted:=False;
    end;
  destructor TMemory.Destroy;
    begin
      Save;
      vars.Free;
      inherited Destroy;
    end;

  function TMemory.unDelimitChinese(s:string):string;
    //�����ַ���������ȥ�ո���
    var
      i:longint;
    begin
      result:=s;
      i:=1;
      while i<length(result)-1 do
        begin
          if ord(result[i]) in [$81..$FF] then //GB ��
            if result[i+2]=' ' then
              begin
                delete(result,i+2,1);
                dec(i);
              end
            else
              inc(i);
          inc(i);
        end;
      result:=Trim(result);
    end;

  procedure TMemory.setVar(name,value:string);
    //���ñ���ֵ
    begin
      setVar(name,0,value);
    end;
  procedure TMemory.setVar(name:string;index:integer;value:string);
    //���ô������ı���ֵ
    begin
      name:=name+'['+inttostr(index)+']';
      vars.values[name]:=unDelimitChinese(value);  //��������ǰӦ��������ȥ�ո���
    end;

  function TMemory.getVar(name:string):string;
    //��ȡ����ֵ
    begin
      result:=getVar(name,0);  //����Ĭ��Ϊ0
    end;
  function TMemory.getVar(name:string;index:integer):string;
    //��ȡ�������ı���ֵ
    begin
      name:=name+'['+inttostr(index)+']';
      result:=vars.Values[name];
    end;
  procedure TMemory.setprop(name,value:string);
    begin
      props.values[name]:=value;
    end;
  function TMemory.getProp(name:string):string;
    begin
      result:=props.Values[name];
    end;
  procedure TMemory.ClearVars;
    //������б���
    begin
      vars.Clear;
    end;

  Procedure TMemory.Save;
    //�������б���
    var filename:string;
    begin
      filename:=bot_id+'.variables';
      Log.Log('variables','���ڱ�������� '+bot_id+' �ı���');
      try
        Vars.SaveToFile(filename);
      except
        Log.Log('variables','���󣺲��ܱ������');
      end;
    end;
  Procedure TMemory.Load;
    //���ر���
    var
      filename:string;
    begin
      filename:=bot_id+'.variables';
      if fileexists(filename) then begin  //�ļ����������
      //  Log.Log('variables','���ڼ��ػ����� '+bot_id+' �ı���');
        Vars.LoadFromFile(filename);
      end;
    end;

end.
