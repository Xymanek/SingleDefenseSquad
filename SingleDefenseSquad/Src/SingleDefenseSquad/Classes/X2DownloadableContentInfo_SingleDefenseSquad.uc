class X2DownloadableContentInfo_SingleDefenseSquad extends X2DownloadableContentInfo;

var config int SquadSizeOverride;

static event OnPostTemplatesCreated()
{
	PatchChosenDefense();
}

static function PatchChosenDefense()
{
	local int i;
	local MissionDefinition MissionDef;
	local int SquadSize, MinSoldiers, CurrentMinSoldiers;

	`log("Patching ChosenAvengerDefense",, 'SingleDefenseSquad');
	i = `TACTICALMISSIONMGR.arrMissions.Find('sType', "ChosenAvengerDefense");

	if (i < 0) {
		`REDSCREEN("Failed to find ChosenAvengerDefense mission definition");
		return;
	}

	MissionDef = `TACTICALMISSIONMGR.arrMissions[i];
	SquadSize = MissionDef.MaxSoldiers;
	MinSoldiers = 0;

	// Fix squad size. Use config value if set, otherwise calculate from old config
	if (default.SquadSizeOverride > 0)
	{
		MissionDef.MaxSoldiers = default.SquadSizeOverride;
		MinSoldiers = 1;
	}
	else
	{
		MissionDef.MaxSoldiers = SquadSize * MissionDef.SquadCount;

		// Collect min required number of soldiers
		foreach MissionDef.SquadSizeMin(CurrentMinSoldiers) {
			MinSoldiers += CurrentMinSoldiers;
		}
	}

	MissionDef.SquadCount = 1;
	MissionDef.SquadSizeMin.Length = 1;
	MissionDef.SquadSizeMin[0] = MinSoldiers;

	`TACTICALMISSIONMGR.arrMissions[i] = MissionDef;
}