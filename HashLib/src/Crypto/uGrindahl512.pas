unit uGrindahl512;

{$I ..\Include\HashLib.inc}

interface

uses
  uHashLibTypes,
  uArrayExtensions,
  uBits,
  uConverters,
  uIHashInfo,
  uHashCryptoNotBuildIn;

type
  TGrindahl512 = class sealed(TBlockHash, ICryptoNotBuildIn, ITransformBlock)

  strict private

    Fm_state, Fm_temp: THashLibUInt64Array;

    class var

      Fs_table_0, Fs_table_1, Fs_table_2, Fs_table_3, Fs_table_4, Fs_table_5,
      Fs_table_6, Fs_table_7: THashLibUInt64Array;

{$REGION 'Consts'}

  const
    ROWS = Int32(8);
    COLUMNS = Int32(13);
    BLANK_ROUNDS = Int32(8);
      {$WARNINGS OFF}
      {$R-}
    s_master_table: array [0 .. 255] of UInt64 = ($C6636397633551A2,
      $F87C7CEB7CCD1326, $EE7777C777952952, $F67B7BF77BF50102,
      $FFF2F2E5F2D11A34, $D66B6BB76B7561C2, $DE6F6FA76F5579F2,
      $91C5C539C572A84B, $603030C0309BA05B, $020101040108060C,
      $CE67678767154992, $562B2BAC2B43FAEF, $E7FEFED5FEB13264,
      $B5D7D771D7E2C493, $4DABAB9AAB2FD7B5, $EC7676C3769D2F5E,
      $8FCACA05CA0A8A0F, $1F82823E827C2142, $89C9C909C912801B,
      $FA7D7DEF7DC5152A, $EFFAFAC5FA912A54, $B259597F59FECD81,
      $8E474707470E8909, $FBF0F0EDF0C1162C, $41ADAD82AD1FC39D,
      $B3D4D47DD4FACE87, $5FA2A2BEA267E1D9, $45AFAF8AAF0FCF85,
      $239C9C469C8C65CA, $53A4A4A6A457F5F1, $E47272D372BD376E,
      $9BC0C02DC05AB677, $75B7B7EAB7CF9F25, $E1FDFDD9FDA93870,
      $3D93937A93F4478E, $4C262698262BD4B3, $6C3636D836ABB473,
      $7E3F3FFC3FE3821F, $F5F7F7F1F7F90408, $83CCCC1DCC3A9E27,
      $683434D034BBB86B, $51A5A5A2A55FF3FD, $D1E5E5B9E56968D0,
      $F9F1F1E9F1C91020, $E27171DF71A53D7A, $ABD8D84DD89AE6D7,
      $623131C43193A657, $2A15155415A87EFC, $0804041004201830,
      $95C7C731C762A453, $4623238C2303CA8F, $9DC3C321C342BC63,
      $3018186018C050A0, $3796966E96DC59B2, $0A05051405281E3C,
      $2F9A9A5E9ABC71E2, $0E07071C07381224, $2412124812906CD8,
      $1B808036806C2D5A, $DFE2E2A5E2517AF4, $CDEBEB81EB194C98,
      $4E27279C2723D2BF, $7FB2B2FEB2E78119, $EA7575CF7585254A,
      $120909240948366C, $1D83833A8374274E, $582C2CB02C7BE8CB,
      $341A1A681AD05CB8, $361B1B6C1BD85AB4, $DC6E6EA36E5D7FFE,
      $B45A5A735AE6C795, $5BA0A0B6A077EDC1, $A452525352A6F7F5,
      $763B3BEC3BC39A2F, $B7D6D675D6EAC29F, $7DB3B3FAB3EF8715,
      $522929A42953F6F7, $DDE3E3A1E3597CF8, $5E2F2FBC2F63E2DF,
      $13848426844C356A, $A653535753AEF1F9, $B9D1D169D1D2D0BB,
      $0000000000000000, $C1EDED99ED2958B0, $40202080201BC09B,
      $E3FCFCDDFCA13E7C, $79B1B1F2B1FF8B0D, $B65B5B775BEEC199,
      $D46A6AB36A7D67CE, $8DCBCB01CB028C03, $67BEBECEBE87A949,
      $723939E439D39637, $944A4A334A66A755, $984C4C2B4C56B37D,
      $B058587B58F6CB8D, $85CFCF11CF229433, $BBD0D06DD0DAD6B7,
      $C5EFEF91EF3954A8, $4FAAAA9EAA27D1B9, $EDFBFBC1FB992C58,
      $86434317432E9139, $9A4D4D2F4D5EB571, $663333CC3383AA4F,
      $1185852285443366, $8A45450F451E8511, $E9F9F9C9F9892040,
      $0402020802100C18, $FE7F7FE77FD51932, $A050505B50B6FBED,
      $783C3CF03CFB880B, $259F9F4A9F946FDE, $4BA8A896A837DDA1,
      $A251515F51BEFDE1, $5DA3A3BAA36FE7D5, $8040401B40369B2D,
      $058F8F0A8F140F1E, $3F92927E92FC4182, $219D9D429D8463C6,
      $703838E038DB903B, $F1F5F5F9F5E90810, $63BCBCC6BC97A551,
      $77B6B6EEB6C79929, $AFDADA45DA8AEACF, $422121842113C697,
      $20101040108060C0, $E5FFFFD1FFB93468, $FDF3F3E1F3D91C38,
      $BFD2D265D2CADAAF, $81CDCD19CD32982B, $180C0C300C602850,
      $2613134C13986AD4, $C3ECEC9DEC215EBC, $BE5F5F675FCED9A9,
      $3597976A97D45FBE, $8844440B4416831D, $2E17175C17B872E4,
      $93C4C43DC47AAE47, $55A7A7AAA74FFFE5, $FC7E7EE37EDD1F3E,
      $7A3D3DF43DF38E07, $C864648B640D4386, $BA5D5D6F5DDED5B1,
      $3219196419C856AC, $E67373D773B53162, $C060609B602D5BB6,
      $1981813281642B56, $9E4F4F274F4EB969, $A3DCDC5DDCBAFEE7,
      $44222288220BCC83, $542A2AA82A4BFCE3, $3B90907690EC4D9A,
      $0B888816882C1D3A, $8C46460346068F05, $C7EEEE95EE3152A4,
      $6BB8B8D6B8B7BD61, $2814145014A078F0, $A7DEDE55DEAAF2FF,
      $BC5E5E635EC6DFA5, $160B0B2C0B583A74, $ADDBDB41DB82ECC3,
      $DBE0E0ADE04176EC, $643232C8328BAC43, $743A3AE83ACB9C23,
      $140A0A280A503C78, $9249493F497EAD41, $0C06061806301428,
      $48242490243BD8AB, $B85C5C6B5CD6D3BD, $9FC2C225C24ABA6F,
      $BDD3D361D3C2DCA3, $43ACAC86AC17C591, $C4626293623D57AE,
      $3991917291E44B96, $3195956295C453A6, $D3E4E4BDE4616EDC,
      $F27979FF79E50D1A, $D5E7E7B1E77964C8, $8BC8C80DC81A8617,
      $6E3737DC37A3B27F, $DA6D6DAF6D4575EA, $018D8D028D040306,
      $B1D5D579D5F2C88B, $9C4E4E234E46BF65, $49A9A992A93FDBAD,
      $D86C6CAB6C4D73E6, $AC5656435686EFC5, $F3F4F4FDF4E10E1C,
      $CFEAEA85EA114A94, $CA65658F6505458A, $F47A7AF37AFD070E,
      $47AEAE8EAE07C989, $1008082008403060, $6FBABADEBAA7B179,
      $F07878FB78ED0B16, $4A2525942533DEA7, $5C2E2EB82E6BE4D3,
      $381C1C701CE04890, $57A6A6AEA647F9E9, $73B4B4E6B4D79531,
      $97C6C635C66AA25F, $CBE8E88DE801468C, $A1DDDD59DDB2F8EB,
      $E87474CB748D2346, $3E1F1F7C1FF84284, $964B4B374B6EA159,
      $61BDBDC2BD9FA35D, $0D8B8B1A8B34172E, $0F8A8A1E8A3C1122,
      $E07070DB70AD3B76, $7C3E3EF83EEB8413, $71B5B5E2B5DF933D,
      $CC666683661D4F9E, $9048483B4876AB4D, $0603030C03180A14,
      $F7F6F6F5F6F10204, $1C0E0E380E702448, $C261619F61255DBA,
      $6A3535D435B3BE67, $AE575747578EE9C9, $69B9B9D2B9BFBB6D,
      $1786862E865C3972, $99C1C129C152B07B, $3A1D1D741DE84E9C,
      $279E9E4E9E9C69D2, $D9E1E1A9E14970E0, $EBF8F8CDF881264C,
      $2B98985698AC7DFA, $22111144118866CC, $D26969BF69656DDA,
      $A9D9D949D992E0DB, $078E8E0E8E1C0912, $3394946694CC55AA,
      $2D9B9B5A9BB477EE, $3C1E1E781EF04488, $1587872A87543F7E,
      $C9E9E989E9094080, $87CECE15CE2A923F, $AA55554F559EE5D1,
      $502828A0285BF0FB, $A5DFDF51DFA2F4F3, $038C8C068C0C050A,
      $59A1A1B2A17FEBCD, $0989891289241B36, $1A0D0D340D682E5C,
      $65BFBFCABF8FAF45, $D7E6E6B5E67162C4, $8442421342269735,
      $D06868BB686D6BD6, $8241411F413E9D21, $2999995299A47BF6,
      $5A2D2DB42D73EEC7, $1E0F0F3C0F782244, $7BB0B0F6B0F78D01,
      $A854544B5496E3DD, $6DBBBBDABBAFB775, $2C16165816B074E8);
    {$R+}
      {$WARNINGS ON}
{$ENDREGION}
    class function CalcTable(i: Int32): THashLibUInt64Array;

    procedure InjectMsg(a_full_process: Boolean);

    class constructor Grindahl512();

  strict protected
    procedure Finish(); override;
    function GetResult(): THashLibByteArray; override;
    procedure TransformBlock(a_data: THashLibByteArray;
      a_index: Int32); override;

  public
    constructor Create();
    procedure Initialize(); override;

  end;

implementation

{ TGrindahl512 }

class function TGrindahl512.CalcTable(i: Int32): THashLibUInt64Array;
var
  j: Int32;
begin
  System.SetLength(result, 256);
  j := 0;
  while j < 256 do
  begin
    result[j] := TBits.RotateRight64(s_master_table[j], i * 8);
    System.Inc(j);
  end;
end;

constructor TGrindahl512.Create;
begin
  Inherited Create(64, 8);
  System.SetLength(Fm_state, ROWS * COLUMNS div 8);
  System.SetLength(Fm_temp, ROWS * COLUMNS div 8);
end;

procedure TGrindahl512.Finish;
var
  padding_size, i: Int32;
  msg_length: UInt64;
  pad: THashLibByteArray;
begin
  padding_size := 2 * BlockSize -
    Int32(Fm_processed_bytes mod UInt32(BlockSize));
  msg_length := (Fm_processed_bytes div UInt64(ROWS)) + 1;

  System.SetLength(pad, padding_size);

  pad[0] := $80;

  TConverters.ConvertUInt64ToBytesSwapOrder(msg_length, pad, padding_size - 8);
  TransformBytes(pad, 0, padding_size - BlockSize);

  Fm_state[0] := TConverters.ConvertBytesToUInt64SwapOrder(pad,
    padding_size - BlockSize);
  InjectMsg(true);

  i := 0;

  while i < BLANK_ROUNDS do
  begin
    InjectMsg(true);
    System.Inc(i);
  end;

end;

function TGrindahl512.GetResult: THashLibByteArray;
begin
  result := TConverters.ConvertUInt64ToBytesSwapOrder(Fm_state,
    COLUMNS - HashSize div ROWS, HashSize div ROWS);
end;

class constructor TGrindahl512.Grindahl512;
var
  LowVal1, LowVal2: Int32;
begin

  System.SetLength(Fs_table_0, System.Length(s_master_table));

{$IFDEF DELPHIXE2_UP}
  LowVal1 := System.Low(s_master_table);
  LowVal2 := System.Low(Fs_table_0);
{$ELSE}
  LowVal1 := 0;
  LowVal2 := 0;
{$ENDIF DELPHIXE2_UP}
  System.Move(s_master_table[LowVal1], Fs_table_0[LowVal2],
    System.SizeOf(s_master_table));

  Fs_table_1 := CalcTable(1);
  Fs_table_2 := CalcTable(2);
  Fs_table_3 := CalcTable(3);
  Fs_table_4 := CalcTable(4);
  Fs_table_5 := CalcTable(5);
  Fs_table_6 := CalcTable(6);
  Fs_table_7 := CalcTable(7);

end;

procedure TGrindahl512.Initialize;
begin
  THashLibArrayHelper<UInt64>.Clear(THashLibGenericArray<UInt64>(Fm_state), UInt64(0));
  THashLibArrayHelper<UInt64>.Clear(THashLibGenericArray<UInt64>(Fm_temp), UInt64(0));

  Inherited Initialize();

end;

procedure TGrindahl512.InjectMsg(a_full_process: Boolean);
var
  u: THashLibUInt64Array;
begin
  Fm_state[ROWS * COLUMNS div 8 - 1] :=
    Fm_state[ROWS * COLUMNS div 8 - 1] xor $01;

  if (a_full_process) then
  begin
    Fm_temp[0] := Fs_table_0[Byte(Fm_state[12] shr 56)] xor Fs_table_1
      [Byte(Fm_state[11] shr 48)] xor Fs_table_2[Byte(Fm_state[10] shr 40)
      ] xor Fs_table_3[Byte(Fm_state[9] shr 32)] xor Fs_table_4
      [Byte(Fm_state[8] shr 24)] xor Fs_table_5[Byte(Fm_state[7] shr 16)
      ] xor Fs_table_6[Byte(Fm_state[6] shr 8)] xor Fs_table_7
      [Byte(Fm_state[5])];
  end;

  Fm_temp[1] := Fs_table_0[Byte(Fm_state[0] shr 56)] xor Fs_table_1
    [Byte(Fm_state[12] shr 48)] xor Fs_table_2[Byte(Fm_state[11] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[10] shr 32)] xor Fs_table_4
    [Byte(Fm_state[9] shr 24)] xor Fs_table_5[Byte(Fm_state[8] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[7] shr 8)] xor Fs_table_7[Byte(Fm_state[6])];

  Fm_temp[2] := Fs_table_0[Byte(Fm_state[1] shr 56)] xor Fs_table_1
    [Byte(Fm_state[0] shr 48)] xor Fs_table_2[Byte(Fm_state[12] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[11] shr 32)] xor Fs_table_4
    [Byte(Fm_state[10] shr 24)] xor Fs_table_5[Byte(Fm_state[9] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[8] shr 8)] xor Fs_table_7[Byte(Fm_state[7])];

  Fm_temp[3] := Fs_table_0[Byte(Fm_state[2] shr 56)] xor Fs_table_1
    [Byte(Fm_state[1] shr 48)] xor Fs_table_2[Byte(Fm_state[0] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[12] shr 32)] xor Fs_table_4
    [Byte(Fm_state[11] shr 24)] xor Fs_table_5[Byte(Fm_state[10] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[9] shr 8)] xor Fs_table_7[Byte(Fm_state[8])];

  Fm_temp[4] := Fs_table_0[Byte(Fm_state[3] shr 56)] xor Fs_table_1
    [Byte(Fm_state[2] shr 48)] xor Fs_table_2[Byte(Fm_state[1] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[0] shr 32)] xor Fs_table_4
    [Byte(Fm_state[12] shr 24)] xor Fs_table_5[Byte(Fm_state[11] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[10] shr 8)] xor Fs_table_7
    [Byte(Fm_state[9])];

  Fm_temp[5] := Fs_table_0[Byte(Fm_state[4] shr 56)] xor Fs_table_1
    [Byte(Fm_state[3] shr 48)] xor Fs_table_2[Byte(Fm_state[2] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[1] shr 32)] xor Fs_table_4
    [Byte(Fm_state[0] shr 24)] xor Fs_table_5[Byte(Fm_state[12] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[11] shr 8)] xor Fs_table_7
    [Byte(Fm_state[10])];

  Fm_temp[6] := Fs_table_0[Byte(Fm_state[5] shr 56)] xor Fs_table_1
    [Byte(Fm_state[4] shr 48)] xor Fs_table_2[Byte(Fm_state[3] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[2] shr 32)] xor Fs_table_4
    [Byte(Fm_state[1] shr 24)] xor Fs_table_5[Byte(Fm_state[0] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[12] shr 8)] xor Fs_table_7
    [Byte(Fm_state[11])];

  Fm_temp[7] := Fs_table_0[Byte(Fm_state[6] shr 56)] xor Fs_table_1
    [Byte(Fm_state[5] shr 48)] xor Fs_table_2[Byte(Fm_state[4] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[3] shr 32)] xor Fs_table_4
    [Byte(Fm_state[2] shr 24)] xor Fs_table_5[Byte(Fm_state[1] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[0] shr 8)] xor Fs_table_7
    [Byte(Fm_state[12])];

  Fm_temp[8] := Fs_table_0[Byte(Fm_state[7] shr 56)] xor Fs_table_1
    [Byte(Fm_state[6] shr 48)] xor Fs_table_2[Byte(Fm_state[5] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[4] shr 32)] xor Fs_table_4
    [Byte(Fm_state[3] shr 24)] xor Fs_table_5[Byte(Fm_state[2] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[1] shr 8)] xor Fs_table_7[Byte(Fm_state[0])];

  Fm_temp[9] := Fs_table_0[Byte(Fm_state[8] shr 56)] xor Fs_table_1
    [Byte(Fm_state[7] shr 48)] xor Fs_table_2[Byte(Fm_state[6] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[5] shr 32)] xor Fs_table_4
    [Byte(Fm_state[4] shr 24)] xor Fs_table_5[Byte(Fm_state[3] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[2] shr 8)] xor Fs_table_7[Byte(Fm_state[1])];

  Fm_temp[10] := Fs_table_0[Byte(Fm_state[9] shr 56)] xor Fs_table_1
    [Byte(Fm_state[8] shr 48)] xor Fs_table_2[Byte(Fm_state[7] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[6] shr 32)] xor Fs_table_4
    [Byte(Fm_state[5] shr 24)] xor Fs_table_5[Byte(Fm_state[4] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[3] shr 8)] xor Fs_table_7[Byte(Fm_state[2])];

  Fm_temp[11] := Fs_table_0[Byte(Fm_state[10] shr 56)] xor Fs_table_1
    [Byte(Fm_state[9] shr 48)] xor Fs_table_2[Byte(Fm_state[8] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[7] shr 32)] xor Fs_table_4
    [Byte(Fm_state[6] shr 24)] xor Fs_table_5[Byte(Fm_state[5] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[4] shr 8)] xor Fs_table_7[Byte(Fm_state[3])];

  Fm_temp[12] := Fs_table_0[Byte(Fm_state[11] shr 56)] xor Fs_table_1
    [Byte(Fm_state[10] shr 48)] xor Fs_table_2[Byte(Fm_state[9] shr 40)
    ] xor Fs_table_3[Byte(Fm_state[8] shr 32)] xor Fs_table_4
    [Byte(Fm_state[7] shr 24)] xor Fs_table_5[Byte(Fm_state[6] shr 16)
    ] xor Fs_table_6[Byte(Fm_state[5] shr 8)] xor Fs_table_7[Byte(Fm_state[4])];

  u := Fm_temp;
  Fm_temp := Fm_state;
  Fm_state := u;

end;

procedure TGrindahl512.TransformBlock(a_data: THashLibByteArray;
  a_index: Int32);
begin
  Fm_state[0] := TConverters.ConvertBytesToUInt64SwapOrder(a_data, a_index);
  InjectMsg(false);

end;

end.
