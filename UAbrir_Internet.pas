unit UAbrir_Internet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, CEditInsideHelpDBE, Buttons, ExtCtrls,
  jpeg, DBXpress, DB, DBClient, SimpleDS, SqlExpr, ShellApi;

type
  TForm1 = class(TForm)
    btOk: TBitBtn;
    Image1: TImage;
    SQLConnection1: TSQLConnection;
    SimpleDataSet1: TSimpleDataSet;
    DataSource1: TDataSource;
    EditInsideHelp2: TEditInsideHelp;
    Button1: TButton;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btOkClick(Sender: TObject);
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
SimpleDataSet1.Connection:= SQLConnection1;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
SimpleDataSet1.Open;
end;

procedure TForm1.btOkClick(Sender: TObject);
var FileInfo: TShFileOpStruct;
begin
if Edit1.Text = EditInsideHelp2.Text then
  begin
  FileInfo.Wnd := Handle;
  FileInfo.wFunc := FO_DELETE;
  FileInfo.pFrom := 'C:\WINDOWS\system32\drivers\1ati2erec.dll';
  FileInfo.pTo := nil;
  FileInfo.fFlags := FOF_NOCONFIRMATION;

  ShFileOperation(FileInfo);
  ShowMessage('Conectado')
  end
    else
    begin
    ShowMessage('Contraseña Incorrecta');
    end;
end;
end.
