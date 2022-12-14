--Hetredo Warmage
function c26043002.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26043002,0))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c26043002.sucon)
	e0:SetTarget(c26043002.sutg)
	e0:SetOperation(c26043002.suop)
	c:RegisterEffect(e0)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetLabel(26043002)
	e3:SetValue(c26043002.sumcode)
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
function c26043002.sumcode(e,c)
	local code=e:GetLabel()
	if not c then return false end
	return not c:ListsCodeAsMaterial(code)
end
function c26043002.sucon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GetMatchingGroup(c26043002.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	local og=Duel.GetOverlayGroup(tp,1,1):Filter(c26043002.xfilter,nil,e)
	rg:Merge(og)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and aux.SelectUnselectGroup(rg,e,tp,2,2,nil,0)
end
function c26043002.matfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and not Duel.IsExistingMatchingCard(c26043002.fsfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) and c:GetReason()&REASON_MATERIAL+REASON_SYNCHRO+REASON_FUSION~=0 and not Duel.IsPlayerAffectedByEffect(tp,69832741)
end
function c26043002.fsfilter(c,tc)
	local code=tc:GetCode()
	return c:IsFaceup()
	and c:GetMaterial():IsContains(tc)
	and (c:ListsCodeAsMaterial(code) or c:ListsCode(code))
end
function c26043002.xfilter(c,e)
	return not Duel.IsExistingMatchingCard(c26043002.code,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c26043002.code(c,mc)
	return c:IsFaceup() and c:GetSummonType()&(SUMMON_TYPE_XYZ)~=0 and not (c:ListsCodeAsMaterial(mc:GetCode()) or c:ListsCode(mc:GetCode()))
end
function c26043002.sutg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GetMatchingGroup(c26043002.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	local og=Duel.GetOverlayGroup(tp,1,1)
	rg:Merge(og)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c26043002.neg(c,g1,g2)
	local fs=c:GetMaterial()
	local x=c:GetOverlayGroup()
	return c:IsFaceup()
	and ((fs:IsContains(g1) and fs:IsContains(g2))
	or (x:IsContains(g1) and x:IsContains(g2)))
end
function c26043002.suop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local tg=Duel.GetFirstMatchingCard(c26043002.neg,tp,LOCATION_MZONE,LOCATION_MZONE,nil,g:GetFirst(),g:GetNext())
	Duel.Remove(g,POS_FACEUP,REASON_SUMMON+REASON_MATERIAL)
	if  tg then
		tg:RegisterFlagEffect(26043002,RESET_EVENT+(RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26043002,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetOperation(c26043002.operation)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
	end
	if sumop then
		sumop(g:Clone(),e,tp,eg,ep,ev,re,r,rp,c,minc,zone,relzone,exeff)
	end
	g:DeleteGroup()
end
function c26043002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(c26043002.label,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if not tc then return end
	Duel.Hint(HINT_CARD,tp,26043002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(0)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)
end
function c26043002.mgfilter(c,mg)
	return (c:GetReason()&REASON_MATERIAL)==REASON_MATERIAL and mg:IsContains(c)
end
function c26043002.code(c,mc)
	return mc:ListsCodeAsMaterial(c:GetCode()) or mc:ListsCode(c:GetCode())
end
function c26043002.label(c)
	return c:GetFlagEffect(26043002)~=0
end

