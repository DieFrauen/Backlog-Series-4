--Shatternal Triumvitrial
function c26046001.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--shatter pendulum scale
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCondition(c26046001.descon)
	e0:SetOperation(c26046001.desop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c26046001.splimit)
	c:RegisterEffect(e1)
	--Change scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26046002,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c26046001.sctg)
	e2:SetOperation(c26046001.scop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26046001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c26046001.spcon)
	e3:SetTarget(c26046001.sptg)
	e3:SetOperation(c26046001.spop)
	c:RegisterEffect(e3)
	--Disable destroyed cards
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c26046001.negbt)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26046001)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	--banish undestroyed
	local e6=e5:Clone()
	e6:SetCode(26046000)
	e6:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e6)
	--I N D E S T R U C T I B L E
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_INDESTRUCTABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end

function c26046001.scfilter(c)
	return c:IsSetCard(0x646) and not ((c:GetLeftScale()==8 and c:GetSequence()==0) or (c:GetRightScale()==8 and c:GetSequence()==1))
end
function c26046001.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,c,0x646) end
	local tg=Duel.GetFirstMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,c,0x646)
	Duel.SetTargetCard(tg)
end
function c26046001.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(10)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(10)
		tc:RegisterEffect(e2)
	end
	Duel.Destroy(c,REASON_EFFECT)
end
function c26046001.splimit(e,se,sp,st)
	return aux.penlimit or se:GetHandler():IsSetCard(0x646)
end
function c26046001.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
		and g:IsExists(Card.IsDestructable,1,nil)
end
function c26046001.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.Destroy(g,REASON_EFFECT)
end
function c26046001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>2 and not eg:IsContains(e:GetHandler())
	and eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)>0
	and eg:FilterCount(Card.IsType,nil,TYPE_SPELL)>0
	and eg:FilterCount(Card.IsType,nil,TYPE_TRAP)>0
end
function c26046001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26046001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c26046001.negbt(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetHandler():GetControler()
	if d==nil then return end
	local tc=nil
	if a:IsSetCard(0x646) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:IsSetCard(0x646) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a
	end
	if not tc then return end
	c26046001.disable(e,tc)
end

function c26046001.shatter(e,tp,tg,group,reason,destination)
	if group==false then tg=Group.FromCards(tg) end
	if Duel.IsPlayerAffectedByEffect(tp,26046001) then
		--Duel.Hint(HINT_CARD,tp,26046001)
		for ec in tg:Iter() do
			if not ec:IsSetCard(0x646) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_DESTROYED)
				e1:SetReset(RESET_CHAIN)
				e1:SetLabelObject(ec)
				e1:SetOperation(c26046001.dis)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	local sc=Duel.Destroy(tg,reason,destination)
	tg=tg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsOnField,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26046000) and #tg>0 then
		if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT) then
			Duel.Hint(HINT_CARD,tp,26046001)
		end
	end
	return sc
end
function c26046001.dis(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.Hint(HINT_CARD,tp,c:GetCode())
	c26046001.disable(e,c)
end
function c26046001.disable(e,c)
	local ec=e:GetHandler()
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(ec)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c26046001.discon)
	e3:SetOperation(c26046001.disop)
	e3:SetLabelObject(c)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,e:GetHandlerPlayer())
end
function c26046001.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject()==re:GetHandler()
end
function c26046001.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26046001)
	Duel.NegateEffect(ev)
end