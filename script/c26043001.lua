--Hetredo Warrior
function c26043001.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26043001,0))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c26043001.sumcon)
	e0:SetTarget(c26043001.sumtg)
	e0:SetOperation(c26043001.sumop)
	c:RegisterEffect(e0)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetLabel(26043001)
	e3:SetValue(c26043001.sumcode)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
end
function c26043001.sumcode(e,c)
	local code=e:GetLabel()
	if not c then return false end
	return not c:ListsCodeAsMaterial(code)
end
function c26043001.sumcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26043001.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c26043001.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26043001.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local tc=Duel.SelectTribute(tp,e:GetHandler(),1,1,g,1-tp,nil,Duel.IsSummonCancelable())
	if tc then
		tc:KeepAlive()
		e:SetLabelObject(tc)
		return true
	end
	return false
end
function c26043001.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local mg=g:GetFirst():GetMaterial():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	mg:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26043001,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetLabelObject(mg)
	e1:SetTarget(c26043001.target)
	e1:SetOperation(c26043001.operation)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	if sumop then
		sumop(g:Clone(),e,tp,eg,ep,ev,re,r,rp,c,minc,zone,relzone,exeff)
	end
	g:DeleteGroup()
end
function c26043001.otfilter(c,tp)
	local mg=c:GetMaterial()
	local g=Duel.GetMatchingGroup(c26043001.mgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,mg)
	return c:IsFaceup() and c:IsReleasable()
	and c:GetSummonType()&(SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_LINK)~=0
	and #g>0 and not mg:IsExists(c26043001.code,1,nil,c)
end
function c26043001.mgfilter(c,mg)
	return (c:GetReason()&REASON_MATERIAL)==REASON_MATERIAL and mg:IsContains(c)
end
function c26043001.code(c,mc)
	return mc:ListsCodeAsMaterial(c:GetCode()) or mc:ListsCode(c:GetCode())
end
function c26043001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	local op=1-tp
	local ft=Duel.GetLocationCount(op,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(op,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if chk==0 then return #g>0 and ft>0 end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(op,ft,ft,nil)
	end
	Duel.SetTargetCard(g)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26043001.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=1-tp
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg==0 or ft<#sg or (#sg>1 and Duel.IsPlayerAffectedByEffect(op,CARD_BLUEEYES_SPIRIT)) then return end
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,op,op,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end
