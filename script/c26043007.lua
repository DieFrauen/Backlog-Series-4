--Hetredoximus World Eugenesis
function c26043007.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,26043001,26043002,26043003)
	--Extra Monsters cannot activate their effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c26043007.accon)
	e1:SetValue(c26043007.aclimit)
	c:RegisterEffect(e1)
	--count
	if not c26043007.global_check then
		c26043007.global_check=true
		c26043007[0]=false
		c26043007[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26043007.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c26043007.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--Send 2 monsters with different names from extra deck to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043007,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c26043007.tgcost)
	e2:SetTarget(c26043007.tgtg)
	e2:SetOperation(c26043007.tgop)
	c:RegisterEffect(e2)
	--DARK FUSION JUMPSCARE
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(26043007)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
end

function c26043007.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c26043007[0] then return end
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:GetSummonLocation()==LOCATION_EXTRA then
			c26043007[0]=true
			if not c26043007[1] then
				if Duel.IsPlayerAffectedByEffect(0,26043007) then
				Duel.Hint(HINT_CARD,1,26043007)
				elseif Duel.IsPlayerAffectedByEffect(1,26043007) then
				Duel.Hint(HINT_CARD,0,26043007)
				end
				c26043007[0]=true
			end
		else return end
	end
end
function c26043007.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26043007[0]=false
	c26043007[1]=false
end
function c26043007.accon(e,tp,eg,ep,ev,re,r,rp)
	return c26043007[0]
end
function c26043007.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local mat=rc:GetMaterial()
	return rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	and re:IsActiveType(TYPE_MONSTER)
	and not mat:IsExists(c26043007.code,1,nil,mat,rc)
end
function c26043007.code(c,mat,rc)
	return (rc:ListsCodeAsMaterial(c:GetCode()) or rc:ListsCode(c:GetCode()))
end
function c26043007.cfilter(c,tp)
	local REASON=REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK 
	return c:IsAbleToRemoveAsCost()
	and c:IsMonster()
	and c:GetReason()&REASON~=0
	and not Duel.IsPlayerAffectedByEffect(tp,69832741)
end
function c26043007.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26043007.cfilter,tp,0,LOCATION_GRAVE,1,nil,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,c26043007.cfilter,tp,0,LOCATION_GRAVE,1,1,nil,1-tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c26043007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return #g>0 and e:GetHandler():GetFlagEffect(26043007)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end

function c26043007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		-- Negate its effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:ListsCodeAsMaterial(code) or tc:ListsCode(code) then
			e:GetHandler():RegisterFlagEffect(26043007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26043007,1))
		end
	end
	e:SetLabel(0)
end