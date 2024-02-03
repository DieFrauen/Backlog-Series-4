--Megiddon - Great Magnitude
function c26042004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26042004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26042004.target)
	e1:SetOperation(c26042004.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26042004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(0)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,26042004)
	e2:SetCondition(c26042004.thcon)
	e2:SetTarget(c26042004.thtg)
	e2:SetOperation(c26042004.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetLabel(1)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c26042004.listed_names={26042001}
function c26042004.opfilter(c)
	return c:IsFaceup() and c:IsReleasableByEffect()
end
function c26042004.filter(c,e,tp,mg,ft,name)
	if not c:IsRitualMonster()
		or not c:IsSetCard(0x1642)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		or (name==true and not c:IsCode(26042001))
		then return false end
	local mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	local pdk,odk=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local dk=pdk-odk
	local lv=c:GetLevel()
	local p1,p2,p=0,0,tp
	if dk>0 then 
		p1=dk; 
	elseif dk<0 then
		dk=math.abs(dk); p2=dk; p=1-tp
	end
	if ((p1>0 and Duel.IsPlayerCanDiscardDeck(tp,p1))
	or (p2>0 and Duel.IsPlayerCanDiscardDeck(1-tp,p2)))
	and
	((ft>0 and 
	(  mg:CheckWithSumGreater(Card.GetRitualLevel,lv-dk,c)))
	or mg:IsExists(c26042005.filterF,1,nil,tp,mg,c,lv-dk)) then return true end
	return (ft>0 and 
	(mg:CheckWithSumGreater(Card.GetRitualLevel,lv,c)))
	or mg:IsExists(c26042005.filterF,1,nil,tp,mg,c,lv)
end
function c26042004.filterF(c,tp,mg,rc,lv)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,lv,1,99,rc)
	else return false end
end
function c26042004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c26042004.opfilter,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c26042004.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,ft,false)
		or Duel.IsExistingMatchingCard(c26042004.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,ft,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,  tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,0)
end
function c26042004.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,tc,tc)
	local mg2=Duel.GetMatchingGroup(c26042004.opfilter,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(c26042004.filter,tp,LOCATION_HAND,0,nil,e,tp,mg1,ft,false)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26042004.filter),tp,LOCATION_GRAVE,0,nil,e,tp,mg1,ft,true)
	g1:Merge(g2)
	local tg=g1:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	mg1:Sub(tg)
	local pdk,odk=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local dk=pdk-odk
	local lv=tc:GetLevel()
	local p1,p2,p=0,0,tp
	if dk>0 then 
		p1=dk; 
	elseif dk<0 then
		dk=math.abs(dk); p2=dk; p=1-tp
	end
	local mat=Group.CreateGroup()
	if tc then
		local lvm=math.max(1,lv-dk)
		if mg1:CheckWithSumGreater(Card.GetRitualLevel,lvm,tc)
		and (dk<lv or Duel.SelectYesNo(tp,aux.Stringid(26042004,1))) then
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,lvm,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg1:FilterSelect(tp,c26042006.filterF,1,1,nil,tp,mg1,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,lvm,tc)
				mat:Merge(mat2)
			end
		end
		local mlv=0
		if #mat>0 then mlv=mat:GetSum(Card.GetLevel) else mlv=0 end
		if mlv<lv then
			mlv=lv-mlv
			local dkg=Duel.GetDecktopGroup(p,mlv)
			Duel.DiscardDeck(p,lv-mlv,REASON_EFFECT+REASON_RELEASE)
			Duel.DisableShuffleCheck()
			mat:Merge(dkg)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c26042004.cfilter(c,e,tp,opp)
	local lab=e:GetLabel()
	return opp and c:IsPreviousLocation(LOCATION_DECK) and
	((lab==0 and not c:IsReason(REASON_DRAW)) or
	(lab==1 and c:IsSummonPlayer(tp)))
end
function c26042004.thcon(e,tp,eg,ep,ev,re,r,rp)
	local opp=rp~=tp
	return eg:IsExists(c26042004.cfilter,1,nil,e,1-tp,opp) 
end

function c26042004.thfilter(c)
	return (c:IsRitualSpell() or c:IsRitualMonster()) and c:IsAbleToHand()
end
function c26042004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26042004.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26042004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26042004.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end