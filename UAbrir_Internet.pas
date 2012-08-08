unit UAbrir_Internet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, CEditInsideHelpDBE, Buttons, ExtCtrls,
  jpeg, DBXpress, DB, DBClient, SimpleDS, SqlExpr, ShellApi, Registry;

type
  TForm1 = class(TForm)
    btOk: TBitBtn;
    Image1: TImage;
    Conexion: TSQLConnection;
    SimpleDataSet1: TSimpleDataSet;
    DataSource1: TDataSource;
    EditInsideHelp2: TEditInsideHelp;
    Button1: TButton;
    Edit1: TEdit;
    SimpleDataSet1N_ALEATORIO: TIntegerField;
    SimpleDataSet2: TSimpleDataSet;
    SimpleDataSet2NUMEROS: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure SetRegistryData(RootKey: HKEY; Key, Value: string;
  RegDataType: TRegDataType; Data: variant);
    procedure SimpleDataSet1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  const
  clFocused = TColor($00FF8000);



implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
SimpleDataSet1.Connection:= Conexion;
SimpleDataSet2.Connection:= Conexion;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
SimpleDataSet1.Open;
EditInsideHelp2.Text:= SimpleDataSet1N_ALEATORIO.AsString;

end;


//PARA MANEJAR EL REGISTRO DE WINDOWS
procedure TForm1.SetRegistryData(RootKey: HKEY; Key, Value: string;
  RegDataType: TRegDataType; Data: variant);
var
  Reg: TRegistry;
  s: string;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(Key, True) then begin
      try
        if RegDataType = rdUnknown then
          RegDataType := Reg.GetDataType(Value);
        if RegDataType = rdString then
          Reg.WriteString(Value, Data)
        else if RegDataType = rdExpandString then
          Reg.WriteExpandString(Value, Data)
        else if RegDataType = rdInteger then
          Reg.WriteInteger(Value, Data)
        else if RegDataType = rdBinary then begin
          s := Data;
          Reg.WriteBinaryData(Value, PChar(s)^, Length(s));
        end else
          raise Exception.Create(SysErrorMessage(ERROR_CANTWRITE));
      except
        Reg.CloseKey;
        raise;
      end;
      Reg.CloseKey;
    end else
      raise Exception.Create(SysErrorMessage(GetLastError));
  finally
    Reg.Free;
  end;
end;



procedure TForm1.btOkClick(Sender: TObject);
//var FileInfo: TShFileOpStruct;
var sql, Resultado: string; i: integer;
begin
SimpleDataSet1.Open;
//SimpleDataSet1.DataSet.CommandText:='select * from SEC_ALEATORIO';
if Edit1.Text = SimpleDataSet1N_ALEATORIO.AsString  then
  begin
   SetRegistryData(HKEY_CURRENT_USER,
  '\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
  'ProxyEnable', rdInteger, '0');

  ShowMessage('Clave Correcta, Haga clic en OK para abrir el Navegador');
  ShellExecute(Form1.Handle,nil,PChar('https://www.google.com.do/'),'','',SW_SHOWNORMAL);
  //WinExec(PChar('C:\Archivos de programa\Internet Explorer\iexplore.exe'),SW_SHOWNORMAL);

sql:= 'UPDATE aleatorio SET USADO = USADO + 1 WHERE NUMEROS = '''+Edit1.Text+'''';
conexion.Execute(sql, nil, nil);
i:= 1;
if i = 1 then begin

//SimpleDataSet2.DataSet.CommandText:= 'select first 1 NUMEROS  from aleatorio order by rand ()';
SimpleDataSet2.Open;
Resultado:= SimpleDataSet2NUMEROS.AsString;
i:= 2;
if i = 2 then begin

sql:= 'UPDATE SEC_ALEATORIO SET N_ALEATORIO = '''+Resultado+'''';
conexion.Execute(sql, nil, nil);
end;
end;

  Form1.Close;
  end
    else
    begin
    ShowMessage('Contraseña Incorrecta');
    end;
end;


procedure TForm1.SimpleDataSet1AfterOpen(DataSet: TDataSet);
var sql, Resultado: string;
begin
sql := 'UPDATE aleatorio SET USADO = USADO + 1 WHERE NUMEROS = '''+Edit1.Text+'''';
Conexion.Execute(sql,nil,nil);
//SimpleDataSet1.Open;
sql:= 'select first 1 NUMEROS  from aleatorio order by rand ()';
Conexion.Execute(sql,nil,nil);
Resultado:= SimpleDataSet1N_ALEATORIO.AsString;
sql:= 'INSERT INTO SEC_ALEATORIO (N_ALEATORIO) VALUES '''+Resultado+'''';
Conexion.Execute(sql,nil,nil);
end;

end.
