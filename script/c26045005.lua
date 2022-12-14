--Planetheon Dominion
function c26045005.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26045005,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26045005.target)
	e2:SetOperation(c26045005.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26045005,1))
	e3:SetTarget(c26045005.target2)
	e3:SetOperation(c26045005.operation2)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c26045005.mtcon)
	e4:SetOperation(c26045005.mtop)
	c:RegisterEffect(e4)
	
end
function c26045005.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26045005.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(c)
	if #Duel.GetOverlayGroup(tp,1,0) or not Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST) then
		Duel.SendtoGrave(c,REASON_COST)
	end
end
function c26045005.filter(c,e,tp,rp)
	local rk=c:GetRank()
	local fc=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local fc2=Duel.GetOverlayGroup(tp,1,1)
	fc:Merge(fc2)
	return c:IsSetCard(0x645) and rk==#fc and Duel.GetLocationCountFromEx(tp,rp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function c26045005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045005.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26045005.xmfilter(c,e,tp)
	return (c:IsControler(tp) or c:IsAbleToChangeControler()) and not c:IsImmuneToEffect(e) and not c:IsType(TYPE_TOKEN) 
end
function c26045005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045005.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
		local xm=Duel.GetMatchingGroup(c26045005.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,e,tp)
		Duel.Overlay(tc,xm)
		tc:CompleteProcedure()
	end
end

function c26045005.filter2(c,e,tp,rp)
	local rk=c:GetRank()
	local dk1= (rk==#Duel.GetDecktopGroup(tp,rk))
	local dk2= (rk==10 and #Duel.GetDecktopGroup(0,5)+#Duel.GetDecktopGroup(1,5)==10)
	return c:IsSetCard(0x645) and dk1 or dk2 and Duel.GetLocationCountFromEx(tp,rp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end
function c26045005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26045005.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26045005.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26045005.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,rp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
		local rk=tc:GetRank()
		local p,mat,rc=tp,0,rk==10
		Duel.DisableShuffleCheck()
		while rk>0 do
			mat=Duel.GetDecktopGroup(p,1)
			Duel.Overlay(tc,mat)
			if rc then p=1-p end
			rk=rk-1;
		end
		tc:CompleteProcedure()
	end
end