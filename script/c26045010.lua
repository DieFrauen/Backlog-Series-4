--Planetheon Collapse
function c26045010.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attach triggered on summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26045010,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c26045010.atcon)
	e3:SetTarget(c26045010.attg)
	e3:SetOperation(c26045010.atop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3b)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c26045010.dmcon)
	e2:SetTarget(c26045010.dmtg)
	e2:SetOperation(c26045010.dmop)
	c:RegisterEffect(e2)
end
function c26045010.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and Duel.IsBattlePhase()
end
function c26045010.dmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:GetSequence()>=5
end
function c26045010.sat(c)
	return c:IsFaceup() and c:IsCode(26045003,26045006)
end
function c26045010.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26045010.dmfilter(chkc) end
	local sat=Duel.IsExistingMatchingCard(c26045010.sat,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return sat and Duel.IsExistingTarget(c26045010.dmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26045010.dmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local g=tc:GetFirst():GetOverlayGroup()
	local ct=#g
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c26045010.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=tc:GetOverlayGroup()
		local ct=#g
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Damage(p,ct*500,REASON_EFFECT)
	end
end

function c26045010.atcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c26045010.atfilter(c,eg)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and not eg:IsContains(c)
end
function c26045010.xyzfilter(c,mat)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:GetSequence()>=5
end
function c26045010.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c26045010.atfilter(chkc,eg) end
	if chk==0 then return
		Duel.IsExistingMatchingCard(c26045010.atfilter,tp,0,LOCATION_ONFIELD,1,nil,eg)
		and Duel.IsExistingMatchingCard(c26045010.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and c:GetFlagEffect(26045010)==0 end
	local tg=Duel.SelectTarget(tp,c26045010.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(tg)
	c:RegisterFlagEffect(26045010,RESET_CHAIN,0,1)
end

function c26045010.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_XYZ) then return end
	local g1=Duel.GetMatchingGroup(c26045010.atfilter,tp,0,LOCATION_ONFIELD,nil,eg)
	local g=tc:GetOverlayGroup():Select(tp,1,1,nil)
	if #g1>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local sc=g1:Select(1-tp,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(sc))
		Duel.Overlay(tc,sc,true)
	end
end