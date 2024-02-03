--Meggidon - Giant Deluge
function c26042005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26042005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26042005.target)
	e1:SetOperation(c26042005.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26042004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(0)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,26042005)
	e2:SetCondition(c26042005.thcon)
	e2:SetTarget(c26042005.thtg)
	e2:SetOperation(c26042005.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetLabel(1)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c26042005.listed_names={26042002}
function c26042005.ritfilter(c)
	return c:IsPublic() and c:GetType()&TYPE_RITUAL ==0 and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c26042005.filter(c,e,tp,mg1,mg2,ft,name)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRitualMonster()
		or not c:IsSetCard(0x1642)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		or (name==true and not c:IsCode(26042002))
		then return false end
	if ft>0 then
		return mg1:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c) or Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) and mg2:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg1:IsExists(c26042005.filterF,1,nil,tp,mg,c)
		or Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) and mg2:IsExists(c26042005.filterF,1,nil,tp,mg,c)
	end
end
function c26042005.filterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c26042005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c26042005.ritfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c)
		return ft>-1
		and (Duel.IsExistingMatchingCard(c26042005.filter,tp,LOCATION_HAND,0,1,c,e,tp,mg1,mg2,ft,false)
		or Duel.IsExistingMatchingCard(c26042005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2,ft,true)) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c26042005.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c26042005.ritfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(c26042005.filter,tp,LOCATION_HAND,0,nil,e,tp,mg1,mg2,ft,false)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26042005.filter),tp,LOCATION_GRAVE,0,nil,e,tp,mg1,mg2,ft,true)
	g1:Merge(g2)
	local tg=g1:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	local lv=tc:GetLevel()
	if tc then
		local b1=mg1:CheckWithSumGreater(Card.GetRitualLevel,lv,tc)
		local b2=mg2:CheckWithSumGreater(Card.GetRitualLevel,lv,tc)
		local mat=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26042005,2))
		local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26042005,3)},
		{b2,aux.Stringid(26042005,4)})
		if op==1 then
			mg1=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg1:FilterSelect(tp,c26042006.filterF,1,1,nil,tp,mg1,nil,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		elseif op==2 then
			local op=1-tp
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,op,HINTMSG_RELEASE)
				mat=mg2:SelectWithSumGreater(op,Card.GetRitualLevel,lv,tc)
			else
				Duel.Hint(HINT_SELECTMSG,op,HINTMSG_RELEASE)
				mat=mg2:FilterSelect(op,c26042005.filterF,1,1,nil,tp,nil,mg2,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,op,HINTMSG_RELEASE)
				local mat2=mg2:SelectWithSumGreater(op,Card.GetRitualLevel,tc:GetLevel(),tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_RELEASE)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c26042005.cfilter(c,e,tp,opp)
	local lab=e:GetLabel()
	return opp and c:IsPreviousLocation(LOCATION_GRAVE) and
	(lab==0 or
	(lab==1 and c:IsSummonPlayer(tp)))
end
function c26042005.thcon(e,tp,eg,ep,ev,re,r,rp)
	local opp=rp~=tp
	return eg:IsExists(c26042005.cfilter,1,nil,e,1-tp,opp) 
end

function c26042005.thfilter(c)
	return (c:IsRitualSpell() or c:IsRitualMonster()) and c:IsAbleToHand()
end
function c26042005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26042005.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26042005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26042005.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end