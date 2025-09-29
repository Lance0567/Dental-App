unit uGlobal;

interface

uses
  System.SysUtils, System.Classes, FMX.Layouts, System.Types;

procedure AdjustLayoutHeight(ALayout: TLayout; AHeight: Single);

implementation

{ Adjust Layout height for modal required fields }
procedure AdjustLayoutHeight(ALayout: TLayout; AHeight: Single);
begin
  if Assigned(ALayout) then
  begin
    ALayout.Height := AHeight;
  end;
end;

end.
