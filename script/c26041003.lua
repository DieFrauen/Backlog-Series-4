--Xadres Towering Guard
function c26041003.initial_effect(c)
	--Set this card into S/T zones as a Spell
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26041003.condition)
	e1:SetOperation(c26041003.activate)
	c:RegisterEffect(e1)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26043001,0))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c26041003.sumcon)
	e0:SetTarget(c26041003.sumtg)
	e0:SetOperation(c26041003.sumop)
	c:RegisterEffect(e0)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26041003,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c26041003.sqtg)
	e3:SetOperation(c26041003.sqop)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetRange(LOCATION_SZONE)
	e3b:SetLabel(LOCATION_SZONE)
	c:RegisterEffect(e3b)
end

function c26043001.sumcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	return c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and cg:IsExists()
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



function c26041003.tcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE)
	and c:IsType(TYPE_SPELL)
	and (c:GetSequence()==0 or c:GetSequence()==4)
end
function c26041003.column(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c26041003.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE)
	and c:IsType(TYPE_SPELL)
	and (c:GetSequence()==0 or c:GetSequence()==4)
	and c:GetColumnGroup():FilterCount(c26041003.column,nil,c:GetControler())>0 
end
function c26041003.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave(true)
end

function c26041003.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c26041003.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	c:CancelToGrave(true)
	local seq=(1<<c:GetSequence())&0x1f
	if c:IsSummonable(true,e,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,e,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,e,1,seq)
	else
		Duel.MSet(tp,c,true,e,1,seq)
	end
end
function c26041003.sqfilter(c)
	return c:IsSetCard(0x641) and c:IsFaceup() --and not c:GetSequence()>4
end
function c26041003.sqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local range=e:GetLabel()
	if chkc then return chkc:IsLocation(range) and c26041003.sqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26041003.sqfilter,tp,range,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26041003,2))
	Duel.SelectTarget(tp,c26041003.sqfilter,tp,range,0,1,1,c)
end
function c26041003.sqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local p=tc:GetControler()
	Duel.HintSelection(tc)
	Duel.SwapSequence(c,tc)
end